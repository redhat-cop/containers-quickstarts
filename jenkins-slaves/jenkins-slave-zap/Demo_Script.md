# Demo Script

1. Start The [Container Development Kit](https://developers.redhat.com/products/cdk/download/)
2. Create a new project called `zap-demo`
   1. Via cli:
```
$ oc new-project zap-demo
Now using project "zap-demo" on server "https://192.168.42.159:8443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
```
3. Deploy the image to OpenShift: `oc new-build https://github.com/rht-labs/owasp-zap-openshift.git`
```
$ oc new-build https://github.com/rht-labs/owasp-zap-openshift.git
--> Found Docker image 36540f3 (4 weeks old) from Docker Hub for "centos:centos7"

    * An image stream will be created as "centos:centos7" that will track the source image
    * A Docker build using source code from https://github.com/rht-labs/owasp-zap-openshift.git will be created
      * The resulting image will be pushed to image stream "owasp-zap-openshift:latest"
      * Every time "centos:centos7" changes a new build will be triggered

--> Creating resources with label role=jenkins-slave ...
    imagestream "centos" created
    imagestream "owasp-zap-openshift" created
    buildconfig "owasp-zap-openshift" created
--> Success
    Build configuration "owasp-zap-openshift" created and build triggered.
    Run 'oc logs -f bc/owasp-zap-openshift' to stream the build progress.
```
4. Switch to the OpenShift web console and show the build executing
   1. Can capture the image URL here or in the step below ![ZAP Build Log](ZAP_Build_Log.png)
5. Once the build is complete, navigate to "Builds->Images" and copy the registry URL for the new container
   1. Should look like: 172.30.1.1:5000/zap-demo/owasp-zap-openshift ![ZAP Image Stream](ZAP_Image_Stream.png)
6. Deploy Jenkins
   1. Via cli: `oc process openshift//jenkins-ephemeral | oc create -f -`
   2. Show Jenkins being spun up in web console ![Jenkins Deployed](Jenkins_Deployed.png)
```bash
$ oc process openshift//jenkins-ephemeral | oc create -f -
route "jenkins" created
persistentvolumeclaim "jenkins" created
deploymentconfig "jenkins" created
serviceaccount "jenkins" created
rolebinding "jenkins_edit" created
service "jenkins-jnlp" created
service "jenkins" created
```
7. Log in to the Jenkins instance ![Jenkins Main Page](Jenkins_Main_Page.png) ![Jenkins OpenShift Login](Jenkins_OpenShift_Login.png)
8. Click on "Jenkins->Manage Jenkins->Manage Plugins" ![Jenkins Manage Plugins](Jenkins_Manage_Plugins.png)
10. Select the "Available" tab ![Jenkins Available Plugins HTML Publisher](Jenkins_Available_Plugins_HTML_Publisher.png)
11. Filter for "HTML Publisher"
12. Tick the "HTML Publisher" plugin and click "Download now and install after restart"
13. Tick the box "Restart Jenkins when installation is complete and no jobs are running" ![Jenkins Install Plugin And Restart](Jenkins_Install_And_Restart.png)
14. While Jenkins restarts, explain that the HTML Publisher plugin allows us to add reports to the build history and explain that we will show this in more detail later
15. Log back in to Jenkins
16. Click on "Jenkins -> Manage Jenkins -> Configure System" ![Jenkins Manage System](Jenkins_Manage_System.png)
17. Scroll down to the Kubernetes Cloud configuration
   1. Highlight that we are using OpenShift and that the `zap-demo` namespace has already been populated. ![Jenkins Kubernetes Cloud](Jenkins_Kubernetes_Cloud.png)
18. Click on "Add Pod Template" and select "Kubernetes Pod Template" 
   1. NOTE: If using production OpenShift cluster, the Pod and container will likely already be populated.
19. Fill in the "Name" and "Labels" as `zap-demo` ![Jenkins Kubernetes Slave Config](Jenkins_Kube_Slave_Config.png)
20. Click on "Add" under "Containers"
```
Name: jnlp
Docker image: 172.30.1.1:5000/zap-demo/owasp-zap-openshift  << The Docker image registry may be different on different OpenShift installations
Working directory: /tmp                                     << Explain that this MOUNTS a working directory, it does not set the working directory
Command to run slave agent: <blank>
Arguments to pass to the command: ${computer.jnlpmac} ${computer.name}
Allocate pseudo-TTY: Unchecked
```
21. Max number of instances: 1
22. Time in minutes to retain slave when idle: 10
23. Leave all other settings with default values
24. Click "Save"
25. Click "New Item" on the Jenkins main page ![Jenkins New Pipeline](Jenkins_New_Pipeline.png)
26. Set the name to "Example", select "Pipeline" as the project type, then click "OK"
27. Tick the box "Do not allow concurrent builds" ![Jenkins Deny Concurrent Builds](Jenkins_Disable_Concurrent_Builds.png)
28. Insert the pipeline script:
```groovy
stage('Get a ZAP Pod') {
    node('zap-demo') {
        stage('Scan Web Application') {
            sh 'mkdir /tmp/workdir'
            dir('/tmp/workdir') {
                def retVal = sh returnStatus: true, script: '/zap/zap-baseline.py -r baseline.html -t http://<some-web-site>'
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/zap/wrk', reportFiles: 'baseline.html', reportName: 'ZAP Baseline Scan', reportTitles: 'ZAP Baseline Scan'])
                echo "Return value is: ${retVal}"
            }
        }
    }
}
```
29. Set the web address to be scanned and explain the Pipeline script ![Jenkins Set Pipeline Script](Jenkins_Set_Pipeline_Script.png)
30. Switch back to Jenkins and run the Example build, wait for the ZAP baseline scan to complete. ![Jenkins Start Build](Jenkins_Build_Scheduled.png)
   1. While waiting, explain that we could also push in additional and more detailed specifications for the test by either copying in ZAP configurations or mounting Kubernetes ConfigMap file literals as provided by the security teams. These could be configured on a case-by-case basis part of the initial planning with the security team.
   2. The default baseline scan takes about 3 minutes to complete ![Jenkins Scan Console Output](Jenkins_Scan_Console_Output.png)
31. Once the scan is complete, show the saved ZAP report in the build sidebar. ![Jenkins ZAP Report Link](Jenkins_ZAP_Report_Link.png) ![ZAP Report Page](ZAP_Report_Page.png)

* Discuss methods to customize how the ZAP scans are run. 
  * Mounted ConfigMap files?
  * Mounted volumes
  * Download config via HTTP/CURL
  * https://github.com/zaproxy/zaproxy/wiki/Docker

* More detailed options for baseline scan:
  * https://github.com/zaproxy/zaproxy/wiki/ZAP-Baseline-Scan

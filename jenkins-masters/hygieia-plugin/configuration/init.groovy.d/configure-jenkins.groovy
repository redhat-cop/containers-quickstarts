#!/usr/bin/env groovy
import jenkins.model.*
import com.smartcodeltd.jenkinsci.plugins.buildmonitor.BuildMonitorView
import groovy.json.JsonSlurper
import hudson.tools.InstallSourceProperty

import java.util.logging.Level
import java.util.logging.Logger
import org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud
import jenkins.model.JenkinsLocationConfiguration

final def LOG = Logger.getLogger("LABS")

LOG.log(Level.INFO,  'running configure-jenkins.groovy' )

try {
    // delete default OpenShift job
    Jenkins.instance.items.findAll {
        job -> job.name == 'OpenShift Sample'
    }.each {
        job -> job.delete()
    }
} catch (NullPointerException npe) {
   LOG.log(Level.INFO, 'Failed to delete OpenShift Sample job')
}
// create a default build monitor view that includes all jobs
// https://wiki.jenkins-ci.org/display/JENKINS/Build+Monitor+Plugin
if ( Jenkins.instance.views.findAll{ view -> view instanceof com.smartcodeltd.jenkinsci.plugins.buildmonitor.BuildMonitorView }.size == 0){
  view = new BuildMonitorView('Build Monitor','Build Monitor')
  view.setIncludeRegex('.*')
  Jenkins.instance.addView(view)
}



// support custom CSS for htmlreports
// https://stackoverflow.com/questions/35783964/jenkins-html-publisher-plugin-no-css-is-displayed-when-report-is-viewed-in-j
System.setProperty("hudson.model.DirectoryBrowserSupport.CSP", "")

// This is a helper to delete views in the Jenkins script console if needed
// Jenkins.instance.views.findAll{ view -> view instanceof com.smartcodeltd.jenkinsci.plugins.buildmonitor.BuildMonitorView }.each{ view -> Jenkins.instance.deleteView( view ) }

println("WORKAROUND FOR BUILD_URL ISSUE, see: https://issues.jenkins-ci.org/browse/JENKINS-28466")

def hostname = System.getenv('HOSTNAME')
println "hostname> $hostname"

def sout = new StringBuilder(), serr = new StringBuilder()
def proc = "oc get pod ${hostname} -o jsonpath={.metadata.labels.name}".execute()
proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(3000)
println "out> $sout err> $serr"

def sout2 = new StringBuilder(), serr2 = new StringBuilder()
proc = "oc get route ${sout} -o jsonpath={.spec.host}".execute()
proc.consumeProcessOutput(sout2, serr2)
proc.waitForOrKill(3000)
println "out> $sout2 err> $serr2"

def jlc = jenkins.model.JenkinsLocationConfiguration.get()
jlc.setUrl("https://" + sout2.toString().trim())

println("Configuring container cap for k8s, so pipelines won't hang when booting up slaves")

try{
    def kc = Jenkins.instance.clouds.get(0)

    println "cloud found: ${Jenkins.instance.clouds}"

    kc.setContainerCapStr("100")
}
finally {
    //if we don't null kc, jenkins will try to serialise k8s objects and that will fail, so we won't see actual error
    kc = null
}

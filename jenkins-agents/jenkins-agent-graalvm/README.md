# Jenkins GraalVM Agent

[GraalVM](https://www.graalvm.org/docs/introduction/) is a high-performance runtime that provides significant improvements in application performance and efficiency which is ideal for microservices. It is designed for applications written in Java, JavaScript, LLVM-based languages such as C and C++, and other dynamic languages. It removes the isolation between programming languages and enables interoperability in a shared runtime.

This agent extends [the Jenkins Maven Agent shipped with OpenShift](https://access.redhat.com/containers/?tab=overview#/registry.access.redhat.com/openshift3/jenkins-agent-maven-rhel7) to provide a settings.xml that proxies all dependencies through a nexus server deployed to the same namespace. This type of setup makes sense in a Lab setting, such as [Open Innovation Labs CI/CD](https://github.com/rht-labs/labs-ci-cd) environment. For most customer engagements, you'll to update this proxy/password to use an central, enterprise artifact repo which is unlikely to be deployed in the same namespace. Or simply use the OpenShift supplied base image directly and provide artifact repository info in the application build.

## GraalVM Native Image

[GraalVM Native Image](https://www.graalvm.org/reference-manual/native-image/) allows to ahead-of-time compile Java code to a standalone executable, called a native image. This executable includes the application classes, classes from its dependencies, runtime library classes from JDK and statically linked native code from JDK. It does not run on the Java VM, but includes necessary components like memory management and thread scheduling from a different virtual machine, called “Substrate VM”. Substrate VM is the name for the runtime components (like the deoptimizer, garbage collector, thread scheduling etc.). The resulting program has faster startup time and lower runtime memory overhead compared to a Java VM.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-graalvm \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-graalvm \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.

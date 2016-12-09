# Mediating the cake php application with datapower

create the php application in a new project
```
oc new-project cake-datapower
oc new-app --template=cakephp-mysql-example
```

delete the route to make the application unreachable from outside the cluster
```
oc delete route cakephp-mysql-example
```

build the s2i image from the configuration that was previously created in experimentation mode and then stored in the src directory. This assume you have previously built the s2i-datapower image in the datapower project

```
oc new-app datapower/s2i-datapower~https://github.com/raffaelespazzoli/containers-quickstarts#datapower --context-dir=s2i-datapower/cake-php --name=cake-php-frontend
oc patch dc/cake-php-frontend --patch '{"spec":{"template":{"spec":{"containers": [ {  "name" : "cake-php-frontend" , "command" : ["/bin/busybox","sh","/usr/local/s2i/run"] }]}}}}'
oc volume dc/cake-php-frontend --remove --name=cake-php-frontend-volume-1
oc volume dc/cake-php-frontend --remove --name=cake-php-frontend-volume-2
oc set probe dc/cake-php-frontend --readiness -- grep "Domain configured successfully." /drouter/temporary/log/diag-log
oc expose svc cake-php-frontend --port=8080
```

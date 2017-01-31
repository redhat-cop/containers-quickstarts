```
oc new-build --strategy=docker --binary=true --name=oracle
oc start-build oracle --from-dir=. 
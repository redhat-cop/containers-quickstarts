#!/bin/sh

# Restrict watch to operator namespace.
KOPF_NAMESPACED=true

# Restrict watch to specified namespace.
#KOPF_NAMESPACE=...

# Do not attempt to coordinate with other kopf operators.
KOPF_STANDALONE=true

# Priority flag for kopf when running with other kopf operators.
#KOPF_PRIORITY=100

# Custom resource type for kopf peering management.
#KOPF_PEERING=...

# Custom kopf run command line options.
#KOPF_OPTIONS=...

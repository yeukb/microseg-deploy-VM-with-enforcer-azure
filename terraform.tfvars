resource_group_name = "<RG Name>"

location = "<Azure region to deploy the VM. e.g. southeastasia>"

adminUsername = "paloalto"

ssh_public_key = "~/.ssh/id_rsa.pub"

AllowedSourceIPRange = "<Allow Source IP Range. e.g. 1.2.3.4/32 or 0.0.0.0/0>"

vmName = "server01"

vmSize = "Standard_B1s"

cns_api = "<Microsegmentation API Endpoint for your tenant>"

cns_namespace = "<Microsegmentation Name Space to deploy the VM e.g. "/81234567890/production/cluster1">"

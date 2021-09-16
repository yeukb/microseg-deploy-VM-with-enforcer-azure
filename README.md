# Microsegmentation Demo - Deploy a VM with Enforcer

These Terraform templates will deploy a VM on Azure with Enforcer installed and connected to the Prisma Cloud Console.



## Prequisites:
1. Create a cloud auto-registration policy on Prisma Cloud Console
    - Navigate to the namespace where you will deploy the Enforcer
    - Go to Network Security -> Namespaces -> Authorizations
    - click on the "+" sign and create a cloud auto-registration policy
    - Under "Auto-registration":
        - For Cloud Provider, choose Azure.
        - For Claims, enter the key=value pair of "resourcegroups=<RG_Name>"

2. Terraform v1.0 and above

3. SSH key pair



## Deployment
1. Update the "terraform.tfvars" file with the necessary information.

2. Run "terraform init"

3. Run "terraform apply"

4. VM will be deployed. It takes about 10 minutes for it to be fully ready.
    - To see the init scripts progress, you can go to the Azure portal, navigate to this VM resource
    - On the left panel, scroll down to "Serial console" and click on it.

5. The public IP of the VM will be shown in the terraform outputs.



## Removing The Demo Environment

1. Run "terraform destroy"

# Installation of an OpenShift Cluster in an AWS simulated disconnected environment using UPI

This code is provided as a template that can be used to create the infrastructure and the machines needed for a full disconnected environment in AWS.  This is used in conjunction with [this article](https://dev.to/slipperybee/simulating-a-disconnected-upi-installation-of-openshift-on-aws-13bh-temp-slug-9643486).

## Installation instructions
The template can be created using terraform as is by using the default variables.  You are welcome to change as you see fit.

### Initial step
Run `terraform apply` in the root directory to set up the shared enviornment variables.

### Terraform permissions
Following the security principle of least-privileges it is recommended to give the terraform user only the permissions that it needs.  By running terraform in the `user_permissions` directory a number of policies will be created that can be added to the terraform user.  Obviously the user itself needs to have permissions to add policies (which can't be done from terraform itself for obvious reasons).  

These are the permissions that need to be added to added:

``` json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:ListPolicyVersions",
                "iam:DeletePolicyVersion",
                "iam:CreatePolicyVersion",
                "iam:CreatePolicy"
            ],
            "Resource": "*"
        }
    ]
}
```

### Infra
The following services are set up by running terraform in the infra folder

1. VPC with three private subnets
2. Security groups that match the fireall requirements needed by the OpenShift cluster installation
3. Two Network Elastic Load Balancers:
    1.  The `api.` and `api-int.` paths
    2.  The `*.apps` load balancer. 
4. Two private hosted zones in AWS Route 53 to serve as the required DNS server

### S3 Buckets
In order to simulate a disconnected environment an S3 bucket is used as the transfer medium.  A VPC Gateway Endpoint is added to enable access from the private subnets.  Run terraform in the `transfer_bucket` folder.

## Machines
The machines folder is split into two sub-folders; `bastion_registry` and `cluster-nodes`.

### Bastion and Registry
These should be created first as the last-pre-requisite for setting up the disconnected environment.  Theses machines are [Fedora Cloud Instances](https://fedoraproject.org/cloud/download#cloud_launch ) to ensure that podman is installed by default so the necessary container services can be run.

### Cluster Nodes
These should only be created once all the instructions have been followed for the pre-requisites and the cluster is ready to be installed.  The actual images to use will depend on the version you wish to install. 

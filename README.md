# oci-couchbase
[simple](simple) is a Terraform module that will deploy DSE on OCI. Instructions on how to use it are below. Best practices are detailed in [this document](bestpractices.md).

# Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed here.

# Clone the repo
Run the commands:

    git clone https://github.com/cloud-partners/oci-couchbase.git
    cd oci-couchbase/simple
    terraform init

# Deploy
With all that in place, you can run:

    terraform plan

If that all looks good, we can go ahead and apply the deploy:

    terraform apply

# Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

    terraform destroy

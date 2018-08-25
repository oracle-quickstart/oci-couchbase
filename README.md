# oci-couchbase
[simple](simple) is a Terraform module that will deploy Couchbase Server on OCI. Instructions on how to use it are below. Best practices are detailed in [this document](bestpractices.md).

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

## Clone the Module
Now, you'll want a local copy of this repo.  You can make that with the commands:

    git clone https://github.com/cloud-partners/oci-couchbase.git
    cd oci-couchbase/simple
    ls

That should give you this:

![](./images/1%20-%20git%20clone.png)

We now need to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

    terraform init

This gives the following output:

![](./images/2%20-%20terraform%20init.png)

## Deploy
Now for the main attraction.  Let's make sure the plan looks good:

    terraform plan

That gives:

![](./images/2%20-%20terraform%20plan.png)

If that's good, we can go ahead and apply the deploy:

    terraform apply

That gives:

![](./images/2%20-%20terraform%20apply.png)

## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

    terraform destroy

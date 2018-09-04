# Important - This doesn't work yet!

# oci-couchbase
[simple](simple) is a Terraform module that will deploy Couchbase on OCI. Instructions on how to use it are below. Best practices are detailed in [this document](bestpractices.md).

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

![](./images/3%20-%20terraform%20plan.png)

If that's good, we can go ahead and apply the deploy:

    terraform apply

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

![](./images/4%20-%20terraform%20apply.png)

## Connect to the Cluster
Todo

## SSH to a Node
These machines are using Oracle Enterprise Linux (OEL).  The default login is opc.  You can SSH into the machine with a command like this:

    ssh -i ./oci opc@<Public IP Address>

## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

    terraform destroy

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

![](./images/5%20-%20terraform%20destroy.png)

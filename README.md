# oci-couchbase
These are Terraform modules that deploy Couchbase Enterprise on Oracle Cloud Infrastructure (OCI). They are developed jointly by Oracle and Couchbase.

* [simple](simple) is a Terraform module that will deploy Couchbase on OCI. Instructions on how to use it are below.  
* [generator](generator) is a Python script that will create a Terraform module.  It can be used to generate more complex configurations that take advantage of MDS.

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/oracle/oci-quickstart-prerequisites).

## Clone the Module
Now, you'll want a local copy of this repo.  You can make that with the commands:

    git clone https://github.com/oracle-quickstart/oci-couchbase.git
    cd oci-couchbase/simple
    ls

That should give you this:

![](./images/01%20-%20git%20clone.png)

We now need to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

    terraform init

This gives the following output:

![](./images/02%20-%20terraform%20init.png)

## Deploy
Now for the main attraction.  Let's make sure the plan looks good:

    terraform plan

You'll be prompted to enter a value for `var.adminPassword` if you haven't set a default in [variables.tf](./simple/variables.tf). That gives:

![](./images/03%20-%20terraform%20plan.png)

If that's good, we can go ahead and apply the deploy:

    terraform apply

You'll need to enter `yes` when prompted.  The apply should take about seven minutes to run.  Once complete, you'll see something like this:

![](./images/04%20-%20terraform%20apply.png)

When the apply is complete, the infrastructure will be deployed, but cloud-init scripts will still be running.  Those will wrap up asynchronously.  So, it'll be a few more minutes before your cluster is accessible.  Now is a good time to get a coffee.

## Connect to the Cluster
When the `terraform apply` completed, it printed out two values.  One of those is the URL to access Couchbase Server, the other one is for Couchbase Sync Gateway.  First, let's try accessing Server on port 8091 of the public IP.  You should see this:

![](./images/05%20-%20server%20login.png)

Now enter in the username (default `couchbase`) and password you specified in [variables.tf](./simple/variables.tf), or the value you entered when prompted if not defined in the file.  You should now have a view of your cluster and the services running.

![](./images/06%20-%20server.png)

Couchbase runs the admin interface on every node.  So, we could login to any node in the cluster to see this view.

Next, let's access to Sync Gateway on port 4984 of its public IP.  You should see:

![](./images/07%20-%20sync%20gateway.png)

## SSH to a Node
These machines are using Oracle Enterprise Linux (OEL).  The default login is opc.  You can SSH into the machine with a command like this:

    ssh -i ~/.ssh/oci opc@<Public IP Address>

Couchbase is installed under `/opt/couchbase/bin`.  You can debug deployments by investigating the cloud-init log file `/var/log/messages`.  You'll need to `sudo su` to be able to read it.

![](./images/08%20-%20ssh.png)

## View the Cluster in the Console
You can also login to the web console [here](https://console.us-phoenix-1.oraclecloud.com/a/compute/instances) to view the IaaS that is running the cluster.

![](./images/09%20-%20console.png)

## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

    terraform destroy

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

![](./images/10%20-%20terraform%20destroy.png)

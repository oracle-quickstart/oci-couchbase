# Generator

This generates some Terraform to deploy an arbitrary MDS configuration.

# Prerequisites
In addition to the setup described in the main README.md for this repo, you'll need to have a working python 2.x in your path.  You'll also need yaml.  If you're on a Mac and don't have it, you can run:

    pip install pyyaml

# Running the Generator
Now, pick a parameters file.  Alternatively, create your own.  Then run the `deploy.sh` script.  To run it again mds you would run:

    ./deploy.sh mds

That will generate a file called `generated.tf` and copy some base files from simple.  It will then run:

    terraform init
    terraform plan
    terraform apply

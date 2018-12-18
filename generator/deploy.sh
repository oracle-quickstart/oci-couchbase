#! /usr/bin/sh

cp ../simple/network.tf ./
cp ../simple/provider.tf ./

python generator.py parameters/${PARAMETERS_FILE}.yaml

terraform init
terraform plan
#terraform apply

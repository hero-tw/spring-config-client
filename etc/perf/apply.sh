#!/bin/bash
export PATH=$PATH:/usr/local/bin

if [ ! -f .terraform ];
then
   terraform init;
fi
terraform plan
terraform apply --auto-approve
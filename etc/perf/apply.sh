#!/bin/bash

if [ ! -f .terraform ];
then
   terraform init;
fi
terraform plan
terraform apply --auto-approve
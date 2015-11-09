#!/bin/bash

aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --key-name $6 --security-group-id $4 --subnet-id $5 --associate-public-ip-address --iam-instance-profile $7 --user-data install-webserver.sh --debug

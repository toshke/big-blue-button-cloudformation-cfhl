#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive
export AWS_DEFAULT_REGION='${AWS::Region}'
ip_address="${EIP}"
# set output to debug in system log if required, safe to do so, as no sensitive data is present
set -x

# install aws cli
apt-get update && apt-get install -y awscli cloud-guest-utils

# get EIP association status and dissacoite if required
instance_id=$(ec2metadata --instance-id)
allocation_id=$(aws ec2 describe-addresses --public-ips ${!ip_address} --query Addresses[0].AllocationId --output text)
assocation_id=$(aws ec2 describe-addresses --public-ips ${!ip_address} --query Addresses[0].AssociationId --output text)

if [[ "${!assocation_id}" != "None" ]]; then
    aws ec2 disassociate-address --association-id ${!assocation_id}
    # allow half a minute for networking changes to take effect
    sleep 30
fi

aws ec2 associate-address --public-ip ${!ip_address} --instance-id ${!instance_id} --allow-reassociation
# allow for 5 seconds for networking updates on the instance itself
sleep 5
mkdir -p /tmp/bbb-install && \
    cd /tmp/bbb-install && \
    wget https://ubuntu.bigbluebutton.org/bbb-install.sh  && \
    chmod a+x bbb-install.sh && \
    ./bbb-install.sh -v xenial-220 -s ${DomainName} -e ${AdminEmail} -l -g
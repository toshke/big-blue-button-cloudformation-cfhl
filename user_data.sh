#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive
export AWS_DEFAULT_REGION='${AWS::Region}'
ip_address="${EIP}"
# set output to debug in system log if required, safe to do so, as no sensitive data is present
set -x

# install aws cli
apt-get update && \
 apt-get install -y awscli cloud-guest-utils  python3-pip && \
 pip3 install awscli --upgrade

# get EIP association status and dissacoite if required
instance_id=$(ec2metadata --instance-id)
allocation_id=$(aws ec2 describe-addresses --public-ips ${!ip_address} --query Addresses[0].AllocationId --output text)
assocation_id=$(aws ec2 describe-addresses --public-ips ${!ip_address} --query Addresses[0].AssociationId --output text)
handle_id=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${!1:-32} | head -n 1)

if [[ "${!assocation_id}" != "None" ]]; then
    aws ec2 disassociate-address --association-id ${!assocation_id}
    # allow half a minute for networking changes to take effect
    sleep 30
fi

aws ec2 associate-address --public-ip ${!ip_address} --instance-id ${!instance_id} --allow-reassociation
# wait until metadata service returns proper public ip
while :
do
  pub_ip=$(wget -qO- http://169.254.169.254/latest/meta-data/public-ipv4)
  echo "public_ip: ${!pub_ip}"
  if [[ "${!pub_ip}" == "${!ip_address}" ]]; then break; fi
  sleep 1
done
mkdir -p /tmp/bbb-install && \
    cd /tmp/bbb-install

n=0
until [ $n -ge 9 ]
do
    wget https://ubuntu.bigbluebutton.org/bbb-install.sh  && \
    chmod a+x bbb-install.sh && \
   ./bbb-install.sh -v xenial-220 -s ${DomainName} -e ${AdminEmail} -l -g && break
   echo "Previous attempt failed, restarting in 20 seconds.."
   sleep 20
   n=$[$n+1]
done

# create default admin password
ADMIN_PASWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${!1:-32} | head -n 1)
docker exec -e "ADMIN_PASSWORD=${!ADMIN_PASWORD}" greenlight-v2 bundle exec rake user:create[Admin,${AdminEmail},"${!ADMIN_PASSWORD}",admin,]

# user may be already present, hence rendering the data only if previous command succeeds.
if [[ $? == "0" ]]; then
    aws configure set cli_follow_urlparam false
    aws ssm put-parameter --name ${ConfigSSMPath}/admin_password --value "${!ADMIN_PASWORD}" --type SecureString --key-id 'alias/aws/ssm' --overwrite
    aws ssm put-parameter --name ${ConfigSSMPath}/admin_user --value "${AdminEmail}" --type String  --overwrite
    aws ssm put-parameter --name ${ConfigSSMPath}/server_url --value "https://${DomainName}" --type String  --overwrite
fi
echo "BigBlueButton server setup complete!!!"

echo "Signalling setup complete to CFN using id ${!handle_id}"
curl -X PUT -H 'Content-Type:' --data-binary \
    "{\"Status\" : \"SUCCESS\",\"Reason\" : \"BBB Configuration Complete\",\"UniqueId\" : \"${!handle_id}\",\"Data\" : \"Application has completed configuration.\"}" \
    "${WaitHandle}"
## Big Blue Button on AWS

[Big Blue Button](https://bigbluebutton.org/) is an open source solution for online conferencing
and distance learning. This repository contains templates and source code for deploying the solution
on AWS platform. Templates source is compiled into final templates using [cfhighlander](https://github.com/theonestack/cfhighlander) tool.

Features

- Turn-key solution go get BigBlueButton up and running on AWS
- Admin password available in SSM once the stack has been created
- Configurable disk size
- Root disk encrypted by default
- Daily and weekly server backups as Amazon Machine Images (AMI),
  using AWS Backup service
- Connection to the server using AWS Session Manager (SSM)
- Highly extensible and configurable if building your own CloudFormation templates

### TL;DR ###

You will need Route53 Hosted zone to launch BigBlueButton cloudformation
stack using regional-specific template, by clicking on appropriate link below.
Once the CFN stack is created (wait for that `CREATE_COMPLETE` state, you can access your server at `https://${DomainName}` (DomainName being cfn parameter
you provide). Look under SSM Parameter path given by `ConfigSSMPath`, defaulting to `/bigbluebuttong/config` for default
admin credentials.

| Region        |Region name    |   Launch url  |
| ------------- |:-------------:|:-------------:|
| `ap-southeast-2` | Asia Pacific (Sydney) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-southeast-2.amazonaws.com/templates-ap-southeast-2.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `us-east-1` | US East (N. Virginia) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-east-1.amazonaws.com/templates-us-east-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `ap-northeast-1` | Asia Pacific (Tokyo) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-northeast-1.amazonaws.com/templates-ap-northeast-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `ap-northeast-2` | Asia Pacific (Seoul) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-2#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-northeast-2.amazonaws.com/templates-ap-northeast-2.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `ap-southeast-1` | Asia Pacific (Singapore) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-southeast-1.amazonaws.com/templates-ap-southeast-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `ap-south-1` | Asia Pacific (Mumbai) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=ap-south-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-south-1.amazonaws.com/templates-ap-south-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `eu-central-1` | EU (Frankfurt) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-central-1.amazonaws.com/templates-eu-central-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `eu-north-1` | Europe (Stockholm) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=eu-north-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-north-1.amazonaws.com/templates-eu-north-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `eu-west-1` | EU (Ireland) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-west-1.amazonaws.com/templates-eu-west-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `eu-west-2` | Europe (London) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-2#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-west-2.amazonaws.com/templates-eu-west-2.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `eu-west-3` | Europe (Paris) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-3#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-west-3.amazonaws.com/templates-eu-west-3.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `us-east-2` | US East (Ohio) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-east-2.amazonaws.com/templates-us-east-2.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `us-west-1` | US West (N. California) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-west-1.amazonaws.com/templates-us-west-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `us-west-2` | US West (Oregon) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-west-2.amazonaws.com/templates-us-west-2.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `sa-east-1` | South America (Sao Paulo) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=sa-east-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.sa-east-1.amazonaws.com/templates-sa-east-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |
| `ca-central-1` | Canada (Central) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=ca-central-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ca-central-1.amazonaws.com/templates-ca-central-1.cfhighlander.info/templates/bbb/4e122a1/bbb.compiled.yaml)  |

[You can watch the setup on-screen video recording here](https://youtu.be/ViCy0GsNRVQ)

## Intro

This component was initially developed for needs of [AWS Tools And Programming](https://www.meetup.com/Melbourne-AWS-Programming-and-Tools-Meetup/) meetup
workshop. Due recent surge in need for distant learning solutions, it was made further configurable for use in
different educational and enterprise settings. By no means is this final version of the component,
and pull requests and feature requests are welcome.

## Prerequisites

- AWS Account with valid programmatic access credentials (api keys)
- **Valid** Route53 Hosted Zone within AWS Account (e.g. example.com)

If you want to build and publish your own templates, you can do so either through docker (**recommended**), or directly on host
machine. Depending on method used, you will need

- Ruby (tested with v2.5) if building and publishing templates from your own host
- Docker, `docker-compose` and `make`, if using [3musketeers](https://3musketeers.io/) approach

## Stack parameters

`Route53Zone` - valid Route53 zone in your AWS Account. E.g. example.com

`DomainName` - FQDN for BBB server. Must be either same as Route53Zone, or a subdomain e.g. bigbluebutton.example.com

`AdminEmail` - Administrator email. This will be used both for let's ecnrypt SSL certificate registration and for admin user account on BBB server.

`asgInstanceType` - Instance Type for your server. BBB Doco recommends 4cores and 8GB RAM as minimum, hence t3.xlarge is default option

`ImageId` - Amazon Machine Image (AMI) id for your server. Defaults to Ubuntu 18.04 within selected region.

`RootVolumeSpace` - Server size in GB. Defaults to 40

`ConfigSSMPath` - Amazon System Manager Parameter store path, where setup will store default credentials and url. You may change the password from Greenlight UI.
Must start with forward slash `/`.


## Operations


### Default admin credentials

Administrator password for WebUI (Greenlight) is stored in `/bigbluebutton/config/admin_password` SSM Parameter value.
To retrieve it, use command below (or go to [System Manager Web Console](https://console.aws.amazon.com/systems-manager/parameters))

```shell
CONFIG_PATH=/bigbluebutton/config
BBBPASS=$(aws ssm get-parameter --name ${CONFIG_PATH}/admin_password --query Parameter.Value --output text --with-decryption)
BBBUSER=$(aws ssm get-parameter --name ${CONFIG_PATH}/admin_user --query Parameter.Value --output text)
BBBSERVER=$(aws ssm get-parameter --name ${CONFIG_PATH}/server_url --query Parameter.Value --output text)
echo "Login with ${BBBUSER}:${BBBPASS} at ${BBBSERVER}/b/signin"
```

### Logging into your BigBlueButton server via SSM

This solution uses AWS SSM Session Manager by default to connect to your BBB ec2 instance. See **Configuration** section below, if you
wish to use ssh directly. You'll need `ssm:StartSession` and `ssm:TerminateSession` permissions on your API user to do so. Alternatively,
generate cloudformation templates with ssh access enabled (see config below).

```shell
# lookup instance-id. Either look for instance named '' in your ec2 console,
# or execute command below
$ instance_id=$(aws ec2 describe-instances --filters \
     "Name=instance-state-name,Values=running" \
     "Name=tag:Name,Values=BigBlueButton-Server" \
     --query 'Reservations[].Instances[].InstanceId' --output text)

# to log into the instance use ssm
$ aws ssm start-session --target "${instance_id}"

Starting session with SessionId: api.user-0e11294b740b4a77b
$ sudo su
root@ip-10-200-0-208:/var/snap/amazon-ssm-agent/2012# tail /var/log/cloud-init-output.log -n 4

Cloud-init v. 19.4-33-gbb4131a2-0ubuntu1~16.04.1 running 'modules:final' at Tue, 14 Apr 2020 01:49:09 +0000. Up 31.80 seconds.
ci-info: no authorized SSH keys fingerprints found for user ubuntu.
Cloud-init v. 19.4-33-gbb4131a2-0ubuntu1~16.04.1 finished at Tue, 14 Apr 2020 02:01:00 +0000. Datasource DataSourceEc2Local.  Up 742.52 seconds
```

### Updating the stack

**IMPORTANT** it is recommended that you backup the BBB instance before doing any stack updates.BBB Ec2 instances are backed up by default every 24 hours.


## Usage

Simplest way of launching BigBlueButton on AWS is through one of the links from the top of this page. Optionally,
you may want to configure, update, generate and upload your own template to S3. Configuration is preset for `ap-southeast-2` region.


### Generate and build your own templates

If you wish to make customizations from default setup, and  build and publish your own templates rather then using links provided above,
read below for configuration options, as well as on how to build, publish and manage the templates.
Firs step is to clone this repo

```shell
git clone https://github.com/toshke/.git
```
### Configuration

If you wish to tweak the generated templates, update the values in following files, as they are passed in
as configuration to Cfhighlander and Cfndsl templates.

- `bbb.config.yaml`
- `vpc.config.yaml`
- `asg.config.yaml`
- `backup.config.yaml`

All files come with explanation for configuration keys and their values. Some examples are

**Use your own VPC** - Look at `bbb.config.yaml:render_vpc`

**Connect to instances using SSH** - Look at `asg.config.yaml:allow_ssh` and `aws.config.yaml:allow_incoming`

#### AMI and different regions

It is highly advisable to use either Ubuntu 18.04 AMI from Canonical, or AMI crated from your existing BBB
server through backup process. BigBlueButton stability is guaranteed for this host OS, and can't be guaranteed
for others. By default, cloudformation templates will be rednered for `ap-southeast-2` AMI. This is configurable
through `bbb.config.yaml:image_id` configuration value

Use ruby script below to determine what is Ubuntu 16.04 image in your region (you'll need `aws-sdk-ec2`) ruby gem

```ruby
require 'aws-sdk-ec2'
region = 'us-east-1'
ami_name = 'ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20200129'
canonical_id = '099720109477'
regional_client = Aws::EC2::Client.new(region: region)
regional_ami = regional_client.describe_images({ filters: [
      { name: 'name', values: [ami_name] },
      { name: 'owner-id', values: [canonical_id] }
  ] }).images[0].image_id
puts "Image id: #{regional_ami}"
```

Edit `user_data.sh` to modify instance setups script (this may break things).

#### Recommended:  Using docker

Docker method respects `AWS_REGION` and `AWS_DEFAULT_REGION` environment variables

```shell
# first, clone the repo
$ git clone https://github.com/toshke/.git && cd

# build and validate templates
$ make build

# templates can be located in out/yaml folder. to upload to s3 use cfpublish. Use your own bucket
# and desired prefix
$ make publish DIST_BUCKET=templates.cfhighlander.info DIST_PREFIX=cftemplates/big-blue-button [DIST_VERSION=1.0]

```

#### Without docker

```
# first, clone the repo
$ git clone https://github.com/toshke/.git && cd

# install required gems
$ bundle install

# build and validate cf templates
$ cfcompile bbb ---validate

# templates can be located in out/yaml folder. to upload to s3 use cfpublish. Use your own bucket
# and desired prefix
$ cfhighlander cfpublish --validate bbb --dstbucket templates.cfhighlander.info --dstprefix 'cftemplates/big-blue-button' [--version 1.0]
```

After cfpublish command, launch stack url will be displayed in terminal output




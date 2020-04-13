## Big Blue Button on AWS

[Big Blue Button](https://bigbluebutton.org/) is an open source solution for online conferencing
and distance learning. This repository contains templates and source code for deploying the solution
on AWS platform. Templates source is compiled into final templates using [cfhighlander](https://github.com/theonestack/cfhighlander) tool.

### TL;DR ###

You will need Route53 Hosted zone to launch BigBlueButton cloudformation
stack using regional-specific template, by clicking on appropriate link below

| Region        |Region name    |   Launch url  |
| ------------- |:-------------:|:-------------:|
| `ap-southeast-2` | Asia Pacific (Sydney) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-southeast-2.amazonaws.com/templates-ap-southeast-2.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `us-east-1` | US East (N. Virginia) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-east-1.amazonaws.com/templates-us-east-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `ap-northeast-1` | Asia Pacific (Tokyo) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-northeast-1.amazonaws.com/templates-ap-northeast-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `ap-northeast-2` | Asia Pacific (Seoul) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-northeast-2.amazonaws.com/templates-ap-northeast-2.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `ap-southeast-1` | Asia Pacific (Singapore) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-southeast-1.amazonaws.com/templates-ap-southeast-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `ap-south-1` | Asia Pacific (Mumbai) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-south-1.amazonaws.com/templates-ap-south-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `eu-central-1` | EU (Frankfurt) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-central-1.amazonaws.com/templates-eu-central-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `eu-north-1` | Europe (Stockholm) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-north-1.amazonaws.com/templates-eu-north-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `eu-west-1` | EU (Ireland) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-west-1.amazonaws.com/templates-eu-west-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `eu-west-2` | Europe (London) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-west-2.amazonaws.com/templates-eu-west-2.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `eu-west-3` | Europe (Paris) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-west-3.amazonaws.com/templates-eu-west-3.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `us-east-2` | US East (Ohio) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-east-2.amazonaws.com/templates-us-east-2.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `us-west-1` | US West (N. California) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-west-1.amazonaws.com/templates-us-west-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `us-west-2` | US West (Oregon) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-west-2.amazonaws.com/templates-us-west-2.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `sa-east-1` | South America (Sao Paulo) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.sa-east-1.amazonaws.com/templates-sa-east-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |
| `ca-central-1` | Canada (Central) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ca-central-1.amazonaws.com/templates-ca-central-1.cfhighlander.info/templates/bbb/1586751215/bbb.compiled.yaml)  |

## Intro

This component was initially developed for needs of [AWS Tools And Programming](https://www.meetup.com/Melbourne-AWS-Programming-and-Tools-Meetup/) meetup
workshop. Due recent surge in need for distant learning solutions, it was made further configurable for use in
different educational and enterprise settings. By no means is this final version of the component,
and pull requests and feature requests are welcome.

## Prerequisites

- AWS Account with valid programatic access credentials (api keys)
- **Valid** Route53 Hosted Zone within AWS Account (e.g. example.com)

If you want to build and publish your own templates, you can do so either through docker (**recommended**), or directly on host
machine. Depending on method used, you will need

- *Optional* Ruby (tested with v2.5) if building and publishing templates from your own host
- *Optional* Docker, `docker-compose` and `make`, if using [3musketeers](https://3musketeers.io/) approach

## Usage

Simplest way of launching BigBlueButton on AWS is through one of the links from the top of this page. Optionally,
you may want to configure, update, generate and upload your own template to S3. Configuration is preset for `ap-southeast-2` region.

### Parameter descriptions


### Configuration values

If you wish to tweak the generated templates, update the values in following config files

- `bbb.config.yaml`
- `vpc.config.yaml`
- `asg.config.yaml`

All 3 files come with explanation for configuration keys and their values.

**Use your own VPC** - Look at `bbb.config.yaml:render_vpc`
**Connect to instances using SSH** - Look at `asg.config.yaml:allow_ssh` and `aws.config.yaml:allow_incoming`

### Generate and build your own templates


If you prefer to build and publish your own templates rather then using links provided above

#### Recommended:  Using docker

Docker method respects `AWS_REGION` and `AWS_DEFAULT_REGION` environment variables

```shell
# first, clone the repo
$ git clone https://github.com/toshke/cfhl-big-blue-button.git && cd cfhl-big-blue-button

# build and validate templates
$ make build

# templates can be located in out/yaml folder. to upload to s3 use cfpublish. Use your own bucket
# and desired prefix
$ make publish DIST_BUCKET=templates.cfhighlander.info DIST_PREFIX=cftemplates/big-blue-button [DIST_VERSION=1.0]

```

#### Without docker

```
# first, clone the repo
$ git clone https://github.com/toshke/cfhl-big-blue-button.git && cd cfhl-big-blue-button

# install required gems
$ bundle install

# build and validate cf templates
$ cfcompile bbb ---validate

# templates can be located in out/yaml folder. to upload to s3 use cfpublish. Use your own bucket
# and desired prefix
$ cfhighlander cfpublish --validate bbb --dstbucket templates.cfhighlander.info --dstprefix 'cftemplates/big-blue-button' [--version 1.0]
```

After cfpublish command, launch stack url will be displayed in terminal output




## Big Blue Button on AWS


Source code repository for generating [Big Blue Button](https://bigbluebutton.org/) aws cloudformation templates
using [cfhighlander](https://github.com/theonestack/cfhighlander) tool.

### TL;DR ###

You will need Route53 Hosted zone to launch BigBlueButton cloudformation
stack using regional-specific template, by clicking on appropriate link below

| Region        |Region name    |   Launch url  |
| ------------- |:-------------:|:-------------:|
| `ap-southeast-2` | Asia Pacific (Sydney) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-southeast-2.amazonaws.com/templates-ap-southeast-2.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `us-east-1` | US East (N. Virginia) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-east-1.amazonaws.com/templates-us-east-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `ap-northeast-1` | Asia Pacific (Tokyo) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-northeast-1.amazonaws.com/templates-ap-northeast-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `ap-northeast-2` | Asia Pacific (Seoul) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-northeast-2.amazonaws.com/templates-ap-northeast-2.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `ap-southeast-1` | Asia Pacific (Singapore) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-southeast-1.amazonaws.com/templates-ap-southeast-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `ap-south-1` | Asia Pacific (Mumbai) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-south-1.amazonaws.com/templates-ap-south-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `eu-central-1` | EU (Frankfurt) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-central-1.amazonaws.com/templates-eu-central-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `eu-north-1` | Europe (Stockholm) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-north-1.amazonaws.com/templates-eu-north-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `eu-west-1` | EU (Ireland) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-west-1.amazonaws.com/templates-eu-west-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `eu-west-2` | Europe (London) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-west-2.amazonaws.com/templates-eu-west-2.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `eu-west-3` | Europe (Paris) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-west-3.amazonaws.com/templates-eu-west-3.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `us-east-2` | US East (Ohio) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-east-2.amazonaws.com/templates-us-east-2.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `us-west-1` | US West (N. California) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-west-1.amazonaws.com/templates-us-west-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `us-west-2` | US West (Oregon) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-west-2.amazonaws.com/templates-us-west-2.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `sa-east-1` | South America (Sao Paulo) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.sa-east-1.amazonaws.com/templates-sa-east-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |
| `ca-central-1` | Canada (Central) | [![Launch Stack](launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ca-central-1.amazonaws.com/templates-ca-central-1.cfhighlander.info/templates/bbb/snapshot/bbb.compiled.yaml)  |

## Intro

This component was initially developed for needs of [AWS Tools And Programming](https://www.meetup.com/Melbourne-AWS-Programming-and-Tools-Meetup/) meetup
workshop. Due recent surge in need for distant learning solutions, it was made further configurable for use in
different educational and enterprise settings. By no means is this final version of the component,
and pull requests and feature requests are welcome.

## Prerequisites

- AWS Account with valid programatic access credentials (api keys)
- *Valid* Route53 Hosted Zone within AWS Account (e.g. example.com)

## Configuration

TBD

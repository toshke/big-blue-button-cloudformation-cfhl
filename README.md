## Big Blue Button on AWS


Source code repository for generating [Big Blue Button](https://bigbluebutton.org/) aws cloudformation templates
using [cfhighlander](https://github.com/theonestack/cfhighlander) tool. 

### TL;DR ###


Generate cloudformation, and click on the create stack link in the console output. 

```shell
gem install cfhighlander
git clone https://github.com/toshke/cfhl-big-blue-button && cd cfhl-big-blue-button
cfhighlander cfpublish bbb --validate

...

Use following url to launch CloudFormation stack
--> click on the link to launch the stack, provide appropriate parameters <---
https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/create/review?filter=active&templateURL=https://templates.cfhighlander.info.s3.amazonaws.com/ozcloudtoolsmeetup/11-04.beta/bbb.compiled.yaml&stackName=bbb
...
```

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

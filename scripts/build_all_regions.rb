#!/usr/bin/env ruby


require 'aws-sdk-ec2'
require 'aws-sdk-s3'

regions = Aws::EC2::Client.new.describe_regions.regions
ami_name = 'ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20200129'
cannonical_id = '099720109477'

version = ENV.fetch('TEMPLATES_DIST_VERSION', nil)
unless version
  version = `git rev-parse --short HEAD `.sub("\n", "")
  version = "v_#{version}"
end

regions.each do |region|
  region_name = region.region_name

  begin
    regional_client = Aws::EC2::Client.new(region: region_name)
    regional_s3_client = Aws::S3::Client.new(region: region_name)
    regional_ami = regional_client.describe_images({ filters: [
        { name: 'name', values: [ami_name] },
        { name: 'owner-id', values: [cannonical_id] }
    ] }).images[0].image_id

    puts "#{region_name}: #{regional_ami}"
    dst_bucket = "templates-#{region_name}.cfhighlander.info"
    prefix = "templates/bbb"
    puts "Publishing to s3://#{dst_bucket}/#{prefix}/#{version}"

    begin
      regional_s3_client.head_bucket(bucket: dst_bucket)
    rescue => Aws::S3::Errors::NoSuchBucket
      regional_s3_client.create_bucket(bucket: dst_bucket)
      puts "Make bucket : #{dst_bucket}"
      sleep 10
    end

    # execute highlander publish method
    `AWS_DEFAULT_REGION=#{region_name} AWS_REGION=#{region_name} BBB_AMI_ID=#{regional_ami} cfhighlander cfpublish bbb --validate --dstbucket #{dst_bucket} --dstprefix #{prefix} -v #{version}`
    `ls out/yaml`.split("\n").each do |file|
      path = "#{prefix}/#{version}/#{file}"
      puts "Make public #{path}"
      regional_s3_client.put_object_acl({
          acl: "public-read",
          bucket: dst_bucket,
          key: path,
      })
    end
    location = "https://s3.#{region_name}.amazonaws.com/#{dst_bucket}/#{prefix}/#{version}/bbb.compiled.yaml"
    puts "Published template to #{location}"
  rescue => e
    puts STDERR, "Failed to render template for region #{region_name}"
    puts STDERR, e
  end
end

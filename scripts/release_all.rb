#!/usr/bin/env ruby

require 'erb'
require 'aws-sdk-ec2'
require 'aws-sdk-s3'
require 'yaml'

##
# THIS SCRIPT IS FAR AWAY FROM PRODUCTION GRADE
# ANY FAILURES MAY REQUIRE MANUAL CLEANUP
##
$regional_friendly_names = {
    "ap-southeast-2" => "Asia Pacific (Sydney)",
    "us-east-1" => "US East (N. Virginia)",
    "ap-northeast-1" => "Asia Pacific (Tokyo)",
    "ap-northeast-2" => "Asia Pacific (Seoul)",
    "ap-southeast-1" => "Asia Pacific (Singapore)",
    "ap-south-1" => "Asia Pacific (Mumbai)",
    "eu-central-1" => "EU (Frankfurt)",
    "eu-north-1" => "Europe (Stockholm)",
    "eu-west-1" => "EU (Ireland)",
    "eu-west-2" => "Europe (London)",
    "eu-west-3" => "Europe (Paris)",
    "us-east-2" => "US East (Ohio)",
    "us-west-1" => "US West (N. California)",
    "us-west-2" => "US West (Oregon)",
    "sa-east-1" => "South America (Sao Paulo)",
    "ca-central-1" => "Canada (Central)"
}

def publish_regional(ami_name, cannonical_id, region_name, version, vpc_config)
  regional_client = Aws::EC2::Client.new(region: region_name)
  regional_s3_client = Aws::S3::Client.new(region: region_name)
  regional_ami = regional_client.describe_images({ filters: [
      { name: 'name', values: [ami_name] },
      { name: 'owner-id', values: [cannonical_id] }
  ] }).images[0].image_id

  dst_bucket = "templates-#{region_name}.cfhighlander.info"
  prefix = "templates/bbb"
  puts "#{region_name}: Publishing to s3://#{dst_bucket}/#{prefix}/#{version}"
  azs = regional_client.describe_availability_zones.availability_zones
  azs = azs[0..2] if azs.length > 3
  az_names = azs.collect { |it| it.zone_name }
  vpc_config['availability_zones'] = az_names
  File.write('vpc.config.yaml', vpc_config.to_yaml)
  begin
    regional_s3_client.head_bucket(bucket: dst_bucket)
  rescue Aws::S3::Errors::NoSuchBucket
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
  return location
end


def main
  backup_config_file_name = 'vpcconfigbackup.yaml'
  FileUtils.cp 'vpc.config.yaml', backup_config_file_name
  begin
    regions = Aws::EC2::Client.new.describe_regions.regions
    ami_name = 'ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20200129'
    cannonical_id = '099720109477'

    version = ENV.fetch('TEMPLATES_DIST_VERSION', 'snapshot')

    puts "Backup VPC config due regional dependencies"
    FileUtils.cp 'vpc.config.yaml', backup_config_file_name
    vpc_config = YAML.load(File.read backup_config_file_name)
    all_regions = []
    $regional_friendly_names.each do |region_name, region_friendly_name|
      # if region is not available, skip
      break if regions.find { |r| r.region_name == region_name}.length == 0
      begin
        url = publish_regional(ami_name, cannonical_id, region_name, version, vpc_config)
        all_regions << {
            'name' => region_friendly_name,
            'code' => region_name,
            'launch_url' => url
        }
      rescue => e
        puts STDERR, "Failed to render template for region #{region_name}"
        puts STDERR, e
      end
    end
    out = ERB.new(File.read('doc/README.md.erb'), nil, '-').result(OpenStruct.new({'all_regions'=>all_regions}).instance_eval { binding })
    File.write 'README.md', out
  ensure
    puts "Restore default Sydney region config"
    FileUtils.mv backup_config_file_name, 'vpc.config.yaml'
  end
end

main
require 'test/test_helper'
require 'fileutils'

class AWSCliTest < Test::Unit::TestCase
  def setup
    ENV['AWS_ACCESS_KEY_ID'] = "12345"
    ENV['AWS_SECRET_ACCESS_KEY'] = "12345"
    raise "Please install awscli" if `which aws`.empty?
    @awscli = "aws --region us-east-1 --endpoint localhost:10453"
  end

  def teardown
  end

  def test_create_bucket
    `#{@awscli} mb s3://awscli_bucket`
    output = `#{@awscli} ls`
    assert_match(/awscli_bucket/,output)
  end

  def test_store
    File.open(__FILE__,'rb') do |input|
      File.open("/tmp/fakes3_upload",'wb') do |output|
        output << input.read
      end
    end
    output = `#{@awscli} cp /tmp/fakes3_upload s3://awscli_bucket/upload`
    assert_match(/upload/,output)

    FileUtils.rm("/tmp/fakes3_upload")
  end

  def test_acl
    File.open(__FILE__,'rb') do |input|
      File.open("/tmp/fakes3_acl_upload",'wb') do |output|
        output << input.read
      end
    end
    output = `#{@awscli} cp /tmp/fakes3_acl_upload s3://awscli_bucket/acl_upload`
    assert_match(/upload/,output)

    output = `#{@awscli} --force setacl -P s3://awscli_bucket/acl_upload`
  end

  def test_large_store
  end

  def test_multi_directory
  end

  def test_intra_bucket_copy
  end
end

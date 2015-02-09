CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = Figaro.env.s3_bucket_name
  config.aws_acl    = :public_read
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     Figaro.env.s3_access_key,
    secret_access_key: Figaro.env.s3_secret_key, 
    region: 'eu-central-1'
  }
  
end
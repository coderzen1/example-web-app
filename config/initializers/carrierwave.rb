CarrierWave.configure do |config|
 config.storage = :fog

 config.fog_credentials = {
   :provider               => 'AWS',
   :aws_access_key_id      => Rails.application.secrets.s3_access_key_id,
   :aws_secret_access_key  => Rails.application.secrets.s3_secret_access_key,
   :region                 => 'eu-central-1',
   :path_style             => true
 }
 config.fog_directory  = Rails.application.secrets.s3_bucket
 config.fog_public     = true                                        # optional, defaults to true
 config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {}
 config.asset_host     = "https://s3-#{config.fog_credentials[:region]}.amazonaws.com/#{config.fog_directory}"
end

if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    #config.storage = :file
    #config.enable_processing = false
    config.fog_credentials = {
       provider: 'AWS',
       aws_access_key_id: "XXXX",
       aws_secret_access_key: "XXXX"
    }
    config.storage        = :fog
    config.fog_directory = 'reciprocity-development'
    config.fog_public     = true
    config.fog_attributes = { 'Cache-Control' => 'max-age=315576000'}
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET']
    }

    if Rails.env.production?
      config.fog_directory = 'reciprocity-production'
    else
      config.fog_directory = 'reciprocity-development'
    end

    # for heroku
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end
end

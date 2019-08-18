# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :standard do
    process :resize_to_fit => [200, 100]
  end

  def default_url
    "/assets/default.png"
  end
end

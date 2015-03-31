# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :aws
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  version :standard do
    process :resize_to_fit => [960, 720]
  end
  
  version :blog do
    process :resize_to_fill => [214, 276]
  end
  
  version :box do
    process :resize_to_fill => [450, 450]
  end
  
  version :thumb do
    process :resize_to_fill => [100, 100]
  end

end

class Soundfile
  include Mongoid::Document
  field :soundfile, type: String
  field :soundfile_size, type: Integer
  field :soundfile_content_type, type: String
  field :wordpress_id, type: Integer
  field :wordpress_scope, type: String
  mount_uploader :soundfile, AttachmentUploader
  
  embedded_in :soundable, polymorphic: true
  
end

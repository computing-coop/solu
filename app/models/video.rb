class Video
  include Mongoid::Document
  field :videofile, type: String
  field :videofile_size, type: Integer
  field :videofile_content_type, type: String
  field :wordpress_id, type: Integer
  field :wordpress_scope, type: String
  mount_uploader :videofile, AttachmentUploader
  
  embedded_in :videographic, polymorphic: true
  
end

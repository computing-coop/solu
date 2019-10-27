class Pressrelease
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Imageable
  field :title, type: String
  field :attachment, type: String
  field :attachment_size, type: Integer
  field :attachment_content_type, type: String
  field :image_size, type: Integer
  field :image_width, type: Integer
  field :image_height, type: Integer
  field :image_content_type, type: String
  field :published_at, type: Time
  field :body, type: String
  field :published, type: Mongoid::Boolean
  mount_uploader :image, ImageUploader
  mount_uploader :attachment, AttachmentUploader

  slug :title

  before_save :update_image_attributes
  before_save :save_file_metadata
  before_save :check_published_date


  scope :published, -> () { where(published: true)}

  def save_file_metadata
    if attachment.present? && attachment_changed?
      if attachment.file.exists?
        self.attachment_content_type = attachment.file.content_type
        self.attachment_size = attachment.file.size
      end
    end
  end

  def sort_date
    self.published_at
  end

  def check_published_date
    if self.published == true
      self.published_at ||= Time.now
    end
  end

end

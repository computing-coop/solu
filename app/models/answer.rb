class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  field :answer_text, type: String
  field :attachment, type: String
  field :attachment_content_type, type: String
  field :attachment_size, type: Integer
  field :answer_boolean, type: Mongoid::Boolean
  embedded_in :submission
  belongs_to :question
  
  validates_presence_of :question_id
  mount_uploader :attachment, AttachmentUploader


  before_save :save_file_metadata
  
  def save_file_metadata
    if attachment.present? && attachment_changed?
      if attachment.file.exists?
        self.attachment_content_type = attachment.file.content_type
        self.attachment_size = attachment.file.size
      end
    end
  end
  
end

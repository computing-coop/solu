class Answer
  include Mongoid::Document
  field :answer_text, type: String
  field :attachment, type: String
  field :attachment_content_type, type: String
  field :answer_boolean, type: Mongoid::Boolean
  embedded_in :submission
  belongs_to :question
  
  mount_uploader :attachment, AttachmentUploader

end

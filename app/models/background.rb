class Background
  include Mongoid::Document
  field :regular, type: String
  field :regular_size, type: Integer
  field :regular_height, type: Integer
  field :regular_width, type: Integer
  field :regular_content_type, type: String
  field :mobile, type: String
  field :mobile_size, type: Integer
  field :mobile_height, type: Integer
  field :mobile_width, type: Integer
  field :mobile_content_type, type: String
  field :active, type: Mongoid::Boolean
  field :credit, type: String
  mount_uploader :regular, BackgroundUploader
  mount_uploader :mobile, BackgroundUploader
  before_save :update_image_attributes
  
  
  scope :active, -> () { where(active: true) }
  
  def update_image_attributes
    if regular.present? && regular_changed?
      if regular.file.exists?
        self.regular_content_type = regular.file.content_type
        self.regular_size = regular.file.size
        self.regular_width, self.regular_height = `identify -format "%wx%h" #{regular.file.path}`.split(/x/)
      end
    end
    
    if mobile.present? && mobile_changed?
      if mobile.file.exists?
        self.mobile_content_type = mobile.file.content_type
        self.mobile_size = mobile.file.size
        self.mobile_width, self.mobile_height = `identify -format "%wx%h" #{mobile.file.path}`.split(/x/)
      end
    end
    
    
  end
  
  
end

class Participant
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  embedded_in :group
  embeds_one :symposium_registration
  accepts_nested_attributes_for :symposium_registration, reject_if: :all_blank

  
  field :first_name, type: String
  field :last_name, type: String
  field :bio, type: String
  field :avatar, type: String
  field :avatar_width, type: Integer
  field :avatar_height, type: Integer
  field :avatar_content_type, type: String
  field :avatar_size, type: Integer
  field :accepted, type: Boolean, default: false
  field :is_host, type: Mongoid::Boolean
  field :website, type: String
  field :email, type: String

  belongs_to :user
  
  slug :name, scope: :group, history: true
  
  scope :approved, -> () { where(accepted: true) }
  scope :hosts, -> () { where(is_host: true) }
  scope :not_hosts, -> () { where(is_host: false) }
  
  mount_uploader :avatar, ImageUploader
  
  before_save :get_avatar_metadata
  
  def get_avatar_metadata

    if avatar.present? && avatar_changed?
      if avatar.file.exists?
        self.avatar_content_type = avatar.file.content_type
        self.avatar_size = avatar.file.size
        self.avatar_width, self.avatar_height = `identify -format "%wx%h" #{avatar.file.path}`.split(/x/)
      end
    end
  end
  
  def name
    [first_name, last_name].compact.join(' ')
  end
  
  
  def website_formatted
    if website.blank?
      return nil
    elsif website =~ /^http(s*):\/\//i 
      return website
    else
      return "http://#{website}"
    end
  end

end

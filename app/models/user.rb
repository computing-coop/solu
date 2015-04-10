class User
  include Mongoid::Document
  include Mongoid::Slug
  rolify
  validates_uniqueness_of :email
  belongs_to :partner
  accepts_nested_attributes_for :roles
  #has_many :comments
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :name,               type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable
  
  
  # custom HM fields
  field :website,            type: String, default: ""
  field :biography,         type: String

  slug :name
  
  # def self.serialize_from_session(key, salt)
  #   (key = key.first) if key.kind_of? Array
  #   (key = BSON::ObjectId.from_string(key['$oid'])) if key.kind_of? Hash
  #
  #   record = to_adapter.get(key)
  #   record if record && record.authenticatable_salt == salt
  # end
  #
  # def self.serialize_into_session(record)
  #   [record.id.to_s, record.authenticatable_salt]
  # end
  #
  # def to_key
  #   if key = super
  #     key = key.map(&:to_s)
  #   end
  #   key
  # end
  
end

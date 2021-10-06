class Frontitem
  include Mongoid::Document
  field :wideimage, type: String
  field :wideimage_width, type: Integer
  field :wideimage_height, type: Integer
  field :wideimage_size, type: Integer
  field :wideimage_content_type, type: String
  field :smallblurb_background_colour, type: String
  field :smallblurb_text_colour, type: String
  field :smallblurb_hover_colour, type: String
  field :smallblurb_text, type: String
  field :middleblurb_background_color, type: String
  field :middleblurb_text_colour, type: String
  field :middleblurb_hover_colour, type: String
  field :middleblurb_text, type: String
  field :thirdblurb_background_colour, type: String
  field :thirdblurb_text_colour, type: String
  field :thirdblurb_hover_colour, type: String
  field :thirdblurb_text, type: String
  field :url_override, type: String
  field :published, type: Mongoid::Boolean
  field :sortorder, type: Integer
  field :no_text, type: Mongoid::Boolean
  field :dont_scale, type: Mongoid::Boolean
  field :invert_down_arrow_colour, type: Mongoid::Boolean
  embedded_in :node

  mount_uploader :wideimage, BackgroundUploader
  before_save :update_image_attributes

  scope :published, -> () { where(published: true) }
  def update_image_attributes
    if wideimage.present? && wideimage_changed?
      if wideimage.file.exists?
        self.wideimage_content_type = wideimage.file.content_type
        self.wideimage_size = wideimage.file.size
        self.wideimage_width, self.wideimage_height = `identify -format "%wx%h" #{wideimage.file.path}`.split(/x/)
        Rails.logger.error `identify -format "%wx%h" #{wideimage.file.path}`.split(/x/)
        Rails.logger.error i"dentify -format '%wx%h' #{wideimage.file.path}.split(/x/)"
      end
    end
  end

end

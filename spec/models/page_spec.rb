require 'rails_helper'

RSpec.describe Page, type: :model do 
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }

  it { should belong_to(:node) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

end
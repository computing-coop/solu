require 'rails_helper'

RSpec.describe Node, type: :model do 
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }


  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:subdomains) }
end
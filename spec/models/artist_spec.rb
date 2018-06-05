require 'rails_helper'

RSpec.describe Artist, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:country) }
end
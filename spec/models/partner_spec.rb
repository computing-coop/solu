require 'rails_helper'

RSpec.describe Partner, type: :model do
  context 'with validations' do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to have_timestamps }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:country) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:partner).save).to be true
  end

  it 'should require country code to be only two letters' do
    expect(FactoryBot.build(:partner, country: 'FIN').save).to be false
  end

  it 'should not allow a end time to be after a start time' do
    expect(FactoryBot.build(:partner, start_year: 2016, end_year: 2007).save).to be false
  end

  it 'should allow a realistic year' do
    expect(FactoryBot.build(:partner, start_year: 7000).save).to be false
    expect(FactoryBot.build(:partner, end_year: 5).save).to be false
  end

end

require 'rails_helper'
describe "Page creating process", type: :feature do
  let!(:admin_user) { FactoryBot.create(:user, :admin) }

  it 'can list artists in CMS' do
    sign_in admin_user
    # 1. go to root where will be button to Add New Book:
    visit '/admin/artists'
    expect(page).to have_content('Artists')
  end
end
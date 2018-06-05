require 'rails_helper'
describe "Page creating process", type: :feature, js: true do
  let!(:admin_user) { FactoryBot.create(:user, :admin) }

  it 'can create a page' do
    sign_in admin_user
    # 1. go to root where will be button to Add New Book:
    visit '/admin/pages'
    # 2. click on Add New Book button
    first(:link, 'New Page').click
    # 3. Fill form
    fill_in 'page_node_id', with last(:value, 'page_node')
    fill_in 'page_title', with: 'Ulisses'
    # 4. Click on submit form button
    click_button 'Save'
    # 5. Then we should be redirected to show page with book details (book title)
    expect(page).to have_content('Ulisses')
  end
end
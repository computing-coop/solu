require 'rails_helper'
require 'pp'

RSpec.describe 'Static pages', type: :request do 

  let!(:user) { FactoryBot.create(:user, :admin) }
  let(:login_url) { '/users/sign_in' }

  describe "Public access to pages", type: :request do
    it "denies access to pages#new" do

      get new_admin_page_path
 
      expect(response).to redirect_to login_url
    end

    it "denies access to pages#create" do
      
      expect {
        post "/admin/pages", { params: FactoryBot.attributes_for(:page) }
      }.to_not change(Page, :count)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_url
    end
  end
  

end
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
  
  describe 'Admin access to pages', type: :request do
    let!(:admin_user) { FactoryBot.create(:user, :admin) }

    context 'should not allow creating a page with a blank title' do
      before {
        sign_in admin_user

        post "/admin/pages", params: { 
          page: {title: nil, body:  Faker::Lorem.paragraph(2, true, 4), node: Node.find_by(name: "bioart") } 
        }

      }

      it "should return 422" do
        pp response.body
        expect(response).to have_http_status(422)
      end
    end


    context 'should create a page with valid content' do
    
      before {
        sign_in admin_user
        post "/admin/pages", params: { page: {title: 'Test title',
         body:  Faker::Lorem.paragraph(2, true, 4),
          node: Node.find_by(name: "bioart") 
          } 
        }

      }

      it "should return 200" do
        expect(response).to have_http_status(200)
      end

    end
  
  end

end
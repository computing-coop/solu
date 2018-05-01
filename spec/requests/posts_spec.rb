require 'rails_helper'
require 'pp'

RSpec.describe 'Posts', type: :request do 

  let!(:user) { FactoryBot.create(:user, :admin) }
  let(:login_url) { '/users/sign_in' }

  describe "Public access to posts", type: :request do
    it "denies access to posts#new" do

      get new_admin_post_path
 
      expect(response).to redirect_to login_url
    end

    it "denies access to posts#create" do
      
      expect {
        post "/admin/posts", { params: FactoryBot.attributes_for(:post) }
      }.to_not change(Post, :count)

      expect(response).to redirect_to login_url
    end
  end
  

end
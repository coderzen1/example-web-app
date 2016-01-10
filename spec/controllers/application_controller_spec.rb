require 'rails_helper'
RSpec.describe ApplicationController do
  let!(:admin) { create(:user) }

  before do
    sign_in admin
  end

  controller do
    def after_sign_out_path_for(resource)
      super resource
    end

    def after_sign_in_path_for(resource)
      admin_root_path
    end
  end

  describe "After sign-out" do
    it "redirects to the /users/new" do
      expect(controller.after_sign_out_path_for(admin)).to eq new_user_session_path
    end
  end

  describe "After sign-in" do
    it "redirects to the /admin" do
      expect(controller.after_sign_in_path_for(admin)).to eq ('/admin')
    end
  end
end

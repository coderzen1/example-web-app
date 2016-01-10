require 'rails_helper'
RSpec.describe Admin::MyProfileController, type: :controller do
  let(:admin) { create(:user) }
  let(:user_hash) do
    {
      email: "test@test.hr",
      password: "12345678",
      password_confirmation: "12345678",
      current_password: "12345678"
    }
  end

  before do
    sign_in admin
  end

  describe "GET #edit" do
    it "returns edit page" do
      get :edit

      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    context "when valid" do
      it "change email and password" do
        put :update, user: user_hash

        admin.reload

        expect(admin.email).to eql("test@test.hr")
      end
    end

    context "when invalid" do
      it "throw error" do
        user_hash[:current_password] = "wrong_password"

        put :update, user: user_hash

        admin.reload

        expect(admin.password).to eql("12345678")
      end
    end
  end
end

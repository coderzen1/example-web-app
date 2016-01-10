require 'rails_helper'
RSpec.describe Admin::UsersController, type: :controller do
  let!(:company) { create(:company) }
  let!(:company2) { create(:company, name: "Infinum") }
  let(:user) { build(:user) }
  let!(:admin) { create(:user, company: company, role: 0) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "renders index" do
      get :index, company_id: company
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "renders new" do
      get :new, company_id: company

      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "when valid" do
      it "creates a new user" do
        expect { post :create, company_id: company, user: user.as_json }.to change(User, :count).by(1)
        expect(response).to redirect_to(admin_company_users_path(company))
      end
    end

    context "with invalid" do
      it "re-renders new" do
        user.email = "wrong_email"
        post :create, company_id: company, user: user.as_json

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns edit page" do
      get :edit, company_id: company, id: admin

      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    it "change active status and company" do
      admin.active = false
      admin.company = company2

      put :update, company_id: company.id, id: admin, user: admin.as_json

      expect(admin.active).to eql(false)
      expect(admin.company).to eql(company2)
    end
  end

  describe "GET #toggle_activation" do
    it "change active status" do
      get :toggle_activation, company_id: company.id, id: admin

      expect { admin.reload }.to change(admin, :active).from(true).to(false)
    end
  end

  describe "DELETE #destroy" do
    it "deletes user" do
      expect { delete :destroy, company_id: admin.company, id: admin }.to change(User, :count).by(-1)
    end
  end
end

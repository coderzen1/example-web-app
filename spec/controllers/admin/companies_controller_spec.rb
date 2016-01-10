require 'rails_helper'
RSpec.describe Admin::CompaniesController, type: :controller do
  let(:admin) { create(:user, role: 0) }
  let!(:company) { create(:company) }
  let(:admin2) { create(:user, company: company, role: 1) }
  before do
    sign_in admin
  end

  describe "GET #index" do
    before do
      company.logo = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'test-images', 'test_upload_image.jpg'))
      company.save
    end

    it "renders index" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe "GET #index" do
    it "renders index with filtered companies" do
      get :index, q: {name_or_address_street_or_address_city_cont_any: "infinum strojarska"}
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "renders new" do
      get :new

      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe "GET #new" do
    before do
      sign_in admin2
    end
    it "redirects to admin company settings" do
      get :new

      expect(response).to redirect_to(edit_admin_company_path(admin2.company))
    end
  end

  describe "POST #create" do
    context "when valid" do
      it "creates a new Company" do
        company.logo = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'test-images', 'test_upload_image.jpg'))
        expect { post :create, company: company.as_json }.to change(Company, :count).by(1)
        expect(response).to redirect_to(admin_companies_path)
      end
    end

    context "with invalid" do
      it "re-renders new" do
        company.name = nil
        post :create, company: company.as_json

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns edit page" do
      get :edit, id: company.id

      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    it "change company name and custom fields" do
      company.name = "Test"
      put :update, id: company.id, company: company.as_json

      company.reload

      expect(company.name).to eql("Test")
      expect(response).to redirect_to(admin_companies_path)
    end
  end


  describe "DELETE #destroy" do
    it "deletes company" do
      expect { delete :destroy, id: company }.to change(Company, :count).by(-1)
    end
  end
end

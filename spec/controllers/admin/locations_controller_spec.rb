require 'rails_helper'
RSpec.describe Admin::LocationsController, type: :controller do
  let!(:company) { create(:company) }
  let!(:admin) { create(:user, company: company, role: 0) }
  let!(:location) do
    create(:location, company: company, name: 'LocationTest',
                      custom_fields: ['weight', 'height'])
  end
  let(:location_hash) do
    {
      name: 'Location1',
      longitude: '15.9889981',
      latitude: '45.8033957',
      address_attributes: { street: 'Strojarska cesta',
                            number: '22',
                            city: 'Zagreb',
                            zip_code: '10000' },
      custom_fields: ['weight', 'height', 'test']
    }
  end

  let(:location_hash_without_custom_fields) do
    {
      name: 'Location1',
      longitude: '15.9889981',
      latitude: '45.8033957',
      address_attributes: { street: 'Strojarska cesta',
                            number: '22',
                            city: 'Zagreb',
                            zip_code: '10000' }
    }
  end

  before do
    sign_in admin
  end

  describe 'GET #index' do
    context 'without q parameter' do
      it 'returns index page' do
        get :index, company_id: company

        expect(response).to be_success
        expect(response).to render_template(:index)
      end
    end

    context 'with q parameter' do
      it 'renders index with filtered locations' do
        get :index,
            company_id: company,
            q: { name_or_address_street_or_address_city_cont_any: 'location1' }
        expect(response).to be_success
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #new' do
    it 'renders new' do
      get :new, company_id: company

      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'returns edit page' do
      get :edit, company_id: company.id, id: location

      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET #refresh_token' do
    context 'when token_type is show' do
      it 'changes show_token' do
        location = company.locations.create(name: 'Location1')
        old_token = location.show_token
        xhr :get, :refresh_token, company_id: company.id, id: location.id, token_type: 'show'
        location.reload
        expect(location.show_token).not_to eql(old_token)
      end
    end
    context 'when token_type is edit' do
      it 'changes edit_token' do
        location = company.locations.create(name: 'Location1')
        old_token = location.edit_token
        xhr :get, :refresh_token, company_id: company.id, id: location.id, token_type: 'edit'
        location.reload
        expect(location.show_token).not_to eql(old_token)
      end
    end
  end
end

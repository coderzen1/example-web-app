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
      revision: 1,
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

  describe 'POST #create' do
    context 'when valid' do
      it 'creates a new Location and sends API call' do
        stub_request(:post, "#{Settings.ptv.base_uri}/location")
          .with(body: format_json('requests', 'create_location_request.json'))
          .to_return(
            body: format_json_string('responses',
                                     'create_location_response.json'),
            status: 200)

        expect { post :create, company_id: company, location: location_hash }
          .to change(Location, :count).by(1)
        expect(response).to redirect_to(admin_company_locations_path)
      end
    end
  end

  describe 'PUT #update' do
    context 'when custom fields exists' do
      it 'change location name and custom fields and send API call' do
        stub_request(:get, "#{Settings.ptv.base_uri}/location/RPGJNQ614F27S5Q74WJ1G8QG6")
          .with(query: { token: Rails.application.secrets.ptv_api_key,
                         source: "ptv_arrival_app" })
          .to_return(
            body: format_json_string('responses',
                                     'get_location_response.json'),
            status: 200)

        stub_request(:put, "#{Settings.ptv.base_uri}/location")
          .with(body: format_json('requests', 'update_location_request.json'))
          .to_return(
            body: format_json_string('responses',
                                     'update_success_response.json'),
            status: 200)

        location_hash['name'] = 'Test'
        put :update, company_id: company.id, id: location, location: location_hash

        location.reload

        expect(location.name).to eql('Test')
        expect(location.custom_fields.length).to eql(3)
        expect(location.custom_fields).to eql(['weight', 'height', 'test'])
        expect(response).to redirect_to(admin_company_locations_path(company))
      end
    end

    context 'when custom fields dont exists in hash but exists in database' do
      it 'changes location custom fields to []' do
        stub_request(:get, "#{Settings.ptv.base_uri}/location/RPGJNQ614F27S5Q74WJ1G8QG6")
          .with(query: { token: Rails.application.secrets.ptv_api_key,
                         source: "ptv_arrival_app" })
          .to_return(
            body: format_json_string('responses',
                                     'get_location_response.json'),
            status: 200)

        stub_request(:put, "#{Settings.ptv.base_uri}/location")
          .with(body: format_json('requests', 'update_location_without_cfields.json'))
          .to_return(
            body: format_json_string('responses',
                                     'update_success_response.json'),
            status: 200)

        location_hash['name'] = 'Test'
        put :update, company_id: company.id, id: location,
                     location: location_hash_without_custom_fields

        location.reload

        expect(location.custom_fields.length).to eql(0)
        expect(location.custom_fields).to eql([])
        expect(response).to redirect_to(admin_company_locations_path(company))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes company' do
      stub_request(:delete, "#{Settings.ptv.base_uri}/location/RPGJNQ614F27S5Q74WJ1G8QG6")
        .with(query: { token: Rails.application.secrets.ptv_api_key,
                       source: "ptv_arrival_app"})
        .to_return(
          body: format_json_string('responses',
                                   'basic_success_response.json'),
          status: 200)

      expect { delete :destroy, company_id: company, id: location }
        .to change(Location, :count).by(-1)
    end
  end
end

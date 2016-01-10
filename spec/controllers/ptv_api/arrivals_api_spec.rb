require 'rails_helper'
RSpec.describe ArrivalsController, type: :controller do
  let!(:company) { create(:company) }
  let!(:location) { create(:location, company: company) }
  let(:arrival_hash) do
    {
      'pta' => {
        'date' => '23/12/1991',
        'time' => '22:23'
      },
      'vehicle_type' => '1',
      'custom_fields' =>
        {
          'height' => '200',
          'weight' => '450'
        },
      'scemid' => '6UYFRTU4NP'
    }
  end

  let!(:arrival) { location.arrivals.create(arrival_hash) }

  describe 'POST #create' do
    context 'when valid' do
      it 'creates a new arrival' do
        stub_request(:post, "#{Settings.ptv.base_uri}/tour")
          .with(body: format_json('requests', 'create_arrival_request.json'))
          .to_return(
            body: format_json_string(
              'responses', 'create_arrival_response.json'
            ), status: 200)

        expect { post :create, token: location.edit_token, arrival: arrival_hash }
          .to change(Arrival, :count).by(1)

        expect(response).to redirect_to(arrival_new_path(token: location.edit_token))
      end
    end
  end

  describe 'PATCH #update' do
    context 'when valid' do
      it 'updates arrival' do
        stub_request(:put, "#{Settings.ptv.base_uri}/stop/batch")
          .with(body: format_json('requests', 'update_arrival_request.json'))
          .to_return(
            body: format_json_string('responses',
                                     'basic_success_response.json'),
            status: 200)

        xhr :patch, :update, token: location.edit_token, id: arrival.id, arrival: arrival_hash
        arrival.reload

        expect(arrival.vehicle_type).to eql(1)
        expect(arrival.custom_fields['weight']).to eql('450')
        expect(arrival.custom_fields['height']).to eql('200')
      end
    end
  end
end

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

  let(:invalid_arrival_hash) do
    {
      'pta' => {
        'date' => 'zzzzzz',
        'time' => 'zzzzzz'
      },
      'vehicle_type' => '1',
      'custom_fields' =>
       {
         'height' => '200',
         'weight' => '450'
       }
    }
  end
  let!(:arrival) { location.arrivals.create(arrival_hash) }

  # describe 'GET index' do
  #   it 'renders index' do
  #     get :index
  #
  #     expect(response).to be_success
  #     expect(response).to render_template(:index)
  #   end
  # end

  describe 'GET #show' do
    context 'when token is valid' do
      it 'renders show' do
        get :show, token: location.show_token

        expect(response).to be_success
        expect(response).to render_template(:show)
      end
    end

    context 'when token is invalid' do
      it 'raise_error' do
        expect { get :show, token: '11111111112222233334444455555555' }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  describe 'GET #show_vehicles' do
    context 'when token is valid' do
      it 'renders show_vehicles' do
        get :show_vehicles, token: location.show_token

        expect(response).to be_success
        expect(response).to render_template(:show_vehicles)
      end
    end

    context 'when token is invalid' do
      it 'raise_error' do
        expect { get :show_vehicles, token: '11111111112222233334444455555555' }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #new' do
    it 'renders new' do
      get :new, token: location.edit_token

      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with invalid' do
      it 're-renders new' do
        expect { post :create, token: 'wrong_token' }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #edit' do
    it 'creates a modal in arrivals show' do
      xhr :get, :edit, token: location.edit_token, id: arrival.id
      expect(response).to be_success
    end
  end
end

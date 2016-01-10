require 'rails_helper'

RSpec.describe Company, type: :model do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:token) }
  it { should validate_presence_of(:language) }
  it { should belong_to(:address) }
  it { should have_many(:users) }
  it { should have_many(:locations) }
  it { should accept_nested_attributes_for(:address) }
  it { should accept_nested_attributes_for(:locations) }

  it 'should return full address' do
    address = Address.create(street: 'Strojarska',
                          number: 22,
                          city: 'Zagreb',
                          zip_code: 10000
                          )
    company = create(:company, name:'TestCompany', address: address)
    expect(company.full_address).to eq('Strojarska 22 Zagreb 10000')
  end
end

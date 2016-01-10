require 'rails_helper'

RSpec.describe Location, type: :model do

  it { should validate_uniqueness_of(:show_token) }
  it { should validate_uniqueness_of(:edit_token) }
  it { should belong_to(:company) }
  it { should belong_to(:address) }
  it { should validate_presence_of(:name) }
  it { should have_many(:arrivals) }

  it "should create tokens after creating a location" do
    location = Location.create(name: "Location1")

    location.reload

    expect(location.show_token).to_not be_blank
    expect(location.edit_token).to_not be_blank
  end
end

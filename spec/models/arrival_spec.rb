require 'rails_helper'

RSpec.describe Arrival, type: :model do
  it { should belong_to(:location) }
  it { should define_enum_for(:vehicle_types) }
  it { should validate_presence_of(:vehicle_type) }
end

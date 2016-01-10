require 'rails_helper'

RSpec.describe User, type: :model do

  it { should belong_to(:company) }
  it { should define_enum_for(:role) }

  it 'tests user methods' do
    user = User.create()

    expect(user.show_active_status).to eq(t('users_active_yes'))
    expect(user.toggle_activation_message).to eq(t('users_toggle_activation_link_deactivate'))
  end
end

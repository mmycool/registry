require 'rails_helper'

RSpec.describe 'admin price create', settings: false do
  let!(:zone) { create(:zone, id: 1) }

  before do
    login_as create(:admin_user)
  end

  it 'creates new price' do
    expect { post admin_prices_path, price: attributes_for(:price).merge(zone_ids: [1]) }
      .to change { Billing::Price.count }.from(0).to(1)
  end

  it 'saves valid_to' do
    post admin_prices_path, price: attributes_for(:price, valid_to: '2010-07-06 10:30').merge(zone_ids: [1])
    expect(Billing::Price.first.valid_to).to eq(Time.zone.parse('2010-07-06 10:30'))
  end

  it 'redirects to :index' do
    post admin_prices_path, price: attributes_for(:price).merge(zone_ids: [1])
    expect(response).to redirect_to admin_prices_url
  end
end

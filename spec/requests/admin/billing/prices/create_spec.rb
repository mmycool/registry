require 'rails_helper'

RSpec.describe 'admin price create', settings: false do
  let!(:zone) { create(:zone, id: 1) }
  subject(:price) { Billing::Price.first }

  before :example do
    sign_in_to_admin_area
  end

  it 'creates new price' do
    expect { post admin_prices_path, price: attributes_for(:price,
                                                           zone_id: '1',
                                                           effect_time_date: '2010-07-05',
                                                           effect_time_time: '08:00:30')
    }.to change { Billing::Price.count }.from(0).to(1)
  end

  it 'saves zone' do
    post admin_prices_path, price: attributes_for(:price,
                                                  zone_id: '1',
                                                  effect_time_date: '2010-07-05',
                                                  effect_time_time: '08:00:30')
    expect(price.zone_id).to eq(1)
  end

  it 'saves operation category' do
    post admin_prices_path, price: attributes_for(:price,
                                                  zone_id: '1',
                                                  effect_time_date: '2010-07-05',
                                                  effect_time_time: '08:00:30',
                                                  operation_category: Billing::Price.operation_categories.first)
    expect(price.operation_category).to eq(Billing::Price.operation_categories.first)
  end

  it 'saves duration in months' do
    post admin_prices_path, price: attributes_for(:price,
                                                  zone_id: '1',
                                                  effect_time_date: '2010-07-05',
                                                  effect_time_time: '08:00:30',
                                                  duration: '3 mons')
    expect(price.duration).to eq('3 mons')
  end

  it 'saves duration in years' do
    post admin_prices_path, price: attributes_for(:price,
                                                  zone_id: '1',
                                                  effect_time_date: '2010-07-05',
                                                  effect_time_time: '08:00:30',
                                                  duration: '1 year')
    expect(price.duration).to eq('1 year')
  end

  it 'saves effective time' do
    post admin_prices_path, price: attributes_for(:price,
                                                  zone_id: '1',
                                                  effect_time_date: '2010-07-05',
                                                  effect_time_time: '08:00:30')
    expect(price.effect_time).to eq(Time.zone.parse('2010-07-05 08:00:30'))
  end

  it 'saves expiration time' do
    post admin_prices_path, price: attributes_for(:price,
                                                  zone_id: '1',
                                                  effect_time_date: '2010-07-05',
                                                  effect_time_time: '08:00:30',
                                                  expire_time_date: '2010-07-05',
                                                  expire_time_time: '08:00:31')
    expect(price.expire_time).to eq(Time.zone.parse('2010-07-05 08:00:31'))
  end

  it 'redirects to :index' do
    post admin_prices_path, price: attributes_for(:price,
                                                  zone_id: '1',
                                                  effect_time_date: '2010-07-05',
                                                  effect_time_time: '08:00:30')
    expect(response).to redirect_to admin_prices_url
  end
end

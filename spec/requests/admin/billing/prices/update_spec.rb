require 'rails_helper'

RSpec.describe 'admin price update', settings: false do
  before :example do
    sign_in_to_admin_area
  end

  it 'updates zone' do
    price = create(:price)
    create(:zone, id: 2)

    patch admin_price_path(price), price: attributes_for(:price, zone_id: '2',
                                                         effect_time_date: '2010-07-05',
                                                         effect_time_time: '00:00:00')
    price.reload

    expect(price.zone_id).to eq(2)
  end

  it 'updates operation category' do
    price = create(:price, operation_category: Billing::Price.operation_categories.first)

    patch admin_price_path(price),
          price: attributes_for(:price,
                                effect_time_date: '2010-07-05',
                                effect_time_time: '00:00:00',
                                operation_category: Billing::Price.operation_categories.second)
    price.reload

    expect(price.operation_category).to eq(Billing::Price.operation_categories.second)
  end

  it 'updates duration in months' do
    price = create(:price,
                   duration: '3 mons')

    patch admin_price_path(price), price: attributes_for(:price,
                                                         effect_time_date: '2010-07-05',
                                                         effect_time_time: '00:00:00',
                                                         duration: '6 mons')
    price.reload

    expect(price.duration).to eq('6 mons')
  end

  it 'updates price' do
    price = create(:price,
                   price: Money.from_amount(1))

    patch admin_price_path(price), price: attributes_for(:price,
                                                         effect_time_date: '2010-07-05',
                                                         effect_time_time: '00:00:00',
                                                         price: '2')
    price.reload

    expect(price.price).to eq(Money.from_amount(2))
  end

  it 'updates effective time' do
    price = create(:price, effect_time: '2010-07-05 08:00:00')

    patch admin_price_path(price), price: attributes_for(:price,
                                                         effect_time_date: '2010-07-06',
                                                         effect_time_time: '08:00:01')
    price.reload

    expect(price.effect_time).to eq(Time.zone.parse('2010-07-06 08:00:01'))
  end

  it 'updates expiration time' do
    price = create(:price, effect_time: '2010-07-05 08:00:00', expire_time: '2010-07-06 08:00:00')

    patch admin_price_path(price), price: attributes_for(:price,
                                                         effect_time_date: '2010-07-05',
                                                         effect_time_time: '00:00:00',
                                                         expire_time_date: '2010-07-07',
                                                         expire_time_time: '08:00:01')
    price.reload

    expect(price.expire_time).to eq(Time.zone.parse('2010-07-07 08:00:01'))
  end

  it 'redirects to :index' do
    price = create(:price)

    patch admin_price_path(price), price: attributes_for(:price,
                                                         effect_time_date: '2010-07-05',
                                                         effect_time_time: '00:00:00')

    expect(response).to redirect_to admin_prices_url
  end
end

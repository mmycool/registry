require 'rails_helper'

RSpec.describe 'admin price update', settings: false do
  before do
    login_as create(:admin_user)
  end

  it 'updates zone' do
    price = create(:price)
    create(:zone, id: 2)

    patch admin_price_path(price), price: attributes_for(:price).merge(zone_ids: [2])
    price.reload

    expect(price.zone_ids).to eq([2])
  end

  it 'updates operation category' do
    price = create(:price, operation_category: ['create'])

    patch admin_price_path(price),
          price: attributes_for(:price, operation_category: ['update'])
    price.reload

    expect(price.operation_category).to eq(['update'])
  end

  it 'updates duration in months' do
    price = create(:price, duration: ['3 mons'])

    patch admin_price_path(price), price: attributes_for(:price, duration: ['6 mons'])
    price.reload

    expect(price.duration).to eq(['6 mons'])
  end

  it 'updates duration in years' do
    price = create(:price, duration: ['1 year'])

    patch admin_price_path(price), price: attributes_for(:price, duration: ['2 years'])
    price.reload

    expect(price.duration).to eq(['2 years'])
  end

  it 'updates valid_from' do
    price = create(:price, valid_from: '2010-07-05')

    patch admin_price_path(price), price: attributes_for(:price, valid_from: '2010-07-06')
    price.reload

    expect(price.valid_from).to eq(Time.zone.parse('06.07.2010'))
  end

  it 'updates valid_to' do
    price = create(:price, valid_to: '2010-07-05')

    patch admin_price_path(price), price: attributes_for(:price, valid_to: '2010-07-06')
    price.reload

    expect(price.valid_to).to eq(Time.zone.parse('06.07.2010'))
  end

  it 'redirects to :index' do
    price = create(:price)

    patch admin_price_path(price), price: attributes_for(:price)

    expect(response).to redirect_to admin_prices_url
  end
end

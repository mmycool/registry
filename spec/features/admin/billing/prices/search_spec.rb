require 'rails_helper'

RSpec.feature 'Price search in admin area', settings: false do
  given!(:effective_price) { create(:effective_price) }
  given!(:expired_price) { create(:expired_price) }

  background do
    sign_in_to_admin_area
  end

  it 'shows effective prices by default' do
    visit admin_prices_path
    expect(page).to have_css('.price', count: 1)
  end

  it 'filters by given status' do
    visit admin_prices_path
    select Admin::Billing::PricesController.default_status.capitalize, from: 'search_status'
    submit_search_form

    expect(page).to have_css('.price', count: 1)
  end

  def submit_search_form
    find('.price-search-form-search-btn').click
  end
end

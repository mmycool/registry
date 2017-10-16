require 'rails_helper'

RSpec.feature 'New price in admin area', settings: false do
  given!(:zone) { create(:zone, origin: 'com') }

  background do
    login_as create(:admin_user)
  end

  scenario 'it creates new price' do
    visit admin_root_path

    open_list
    open_form
    fill_form
    submit_form

    expect(page).to have_text(t('admin.billing.prices.create.created'))
  end

  def open_list
    click_link_or_button t('admin.base.menu.prices')
  end

  def open_form
    click_link_or_button t('admin.billing.prices.index.new_btn')
  end

  def fill_form
    check 'com'
    check Epp::OperationCategory.all.first
    select '3 months', from: 'price_duration'
    fill_in 'price_price', with: '1'
  end

  def submit_form
    click_link_or_button t('admin.billing.prices.form.create_btn')
  end
end

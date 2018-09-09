require 'test_helper'

class RegistrarAreaSettingsAutoInvoiceTest < ApplicationSystemTestCase
  include ActionView::Helpers::NumberHelper

  setup do
    @registrar = registrars(:bestnames)
    sign_in users(:api_bestnames)
    Application.enable_feature(:auto_invoice)
  end

  teardown do
    Application.disable_feature(:auto_invoice)
  end

  def test_feature_is_not_configurable_when_disabled
    Application.disable_feature(:auto_invoice)
    visit registrar_settings_root_url
    assert_no_text 'Auto-invoicing'
  end

  def test_show_details
    @registrar.update!(auto_invoice: true, low_balance_threshold: 1, top_up_amount: 10,
                       iban: 'DE91 1000 0000 0123 4567 89')
    visit registrar_settings_root_url
    assert_text 'Active true'
    assert_text "Low balance threshold #{Money.from_amount(1).format}"
    assert_text "Top-up amount #{Money.from_amount(10).format}"
    assert_text 'IBAN DE91 1000 0000 0123 4567 89'
  end

  def test_update
    @registrar.update!(auto_invoice: false, low_balance_threshold: nil, top_up_amount: nil,
                       iban: nil)

    visit registrar_settings_root_url
    click_link_or_button 'Edit'
    check 'Active'
    fill_in 'Low balance threshold', with: '100'
    fill_in 'Top-up amount', with: '1000'
    fill_in 'IBAN', with: 'DE91 1000 0000 0123 4567 89'
    click_on 'Update'
    registrars(:bestnames).reload

    assert @registrar.auto_invoice
    assert_equal Money.from_amount(100), @registrar.low_balance_threshold
    assert_equal Money.from_amount(1000), @registrar.top_up_amount
    assert_current_path registrar_settings_root_path
    assert_text 'Settings are updated'
  end
end
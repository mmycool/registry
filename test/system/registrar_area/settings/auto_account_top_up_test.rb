require 'test_helper'

class RegistrarAreaSettingsAutoInvoiceTest < ApplicationSystemTestCase
  setup do
    @registrar = registrars(:bestnames)
    sign_in users(:api_bestnames)

    @original_auto_account_top_up_setting = ENV['auto_account_top_up']
    ENV['auto_account_top_up'] = 'true'
  end

  teardown do
    ENV['auto_account_top_up'] = @original_auto_account_top_up_setting
  end

  def test_feature_is_not_configurable_when_disabled
    ENV['auto_account_top_up'] = 'false'
    visit registrar_settings_root_url
    assert_no_text 'Auto-invoicing'
  end

  def test_show_details
    @registrar.update!(auto_account_top_up_activated: true,
                       auto_account_top_up_low_balance_threshold: 10,
                       auto_account_top_up_amount: 100,
                       auto_account_top_up_iban: 'DE91100000000123456789')

    visit registrar_settings_root_url

    assert_text 'Activated true'
    assert_text "Low balance threshold 10,00"
    assert_text "Top-up amount 100,00"
    assert_text 'IBAN DE91100000000123456789'
  end

  def test_update
    @registrar.update!(auto_account_top_up_activated: false,
                       auto_account_top_up_low_balance_threshold: nil,
                       auto_account_top_up_amount: nil,
                       auto_account_top_up_iban: nil)

    visit registrar_settings_root_url
    click_link_or_button 'Edit'
    check 'Activated'
    fill_in 'Low balance threshold', with: '10'
    fill_in 'Top-up amount', with: '100'
    fill_in 'IBAN', with: 'DE91 1000 0000 0123 4567 89'
    click_on 'Update'
    registrars(:bestnames).reload

    assert @registrar.auto_account_top_up_activated
    assert_equal 10, @registrar.auto_account_top_up_low_balance_threshold
    assert_equal 100, @registrar.auto_account_top_up_amount
    assert_current_path registrar_settings_root_path
    assert_text 'Settings are updated'
  end
end

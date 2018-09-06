require 'test_helper'

class RegistrarAreaSettingsSubscriptionBillingTest < ApplicationSystemTestCase
  include ActionView::Helpers::NumberHelper

  setup do
    @registrar = registrars(:bestnames)
    sign_in users(:api_bestnames)
    Billing::Subscription.enable
  end

  teardown do
    Billing::Subscription.disable
  end

  def test_hide_feature_when_disabled
    Billing::Subscription.disable
    visit registrar_settings_root_url
    assert_no_text 'Subscription billing'
  end

  def test_show_details_when_active
    @registrar.subscription_billing.update!(active: true, low_balance_threshold: 1, top_up_amount: 10)
    visit registrar_settings_root_url
    assert_text "Balance threshold #{number_to_currency(Money.from_amount(1))}"
    assert_text "Top-up amount #{number_to_currency(Money.from_amount(10))}"
  end

  def test_hide_details_when_inactive
    @registrar.subscription_billing.update!(active: false)
    visit registrar_settings_root_url
    assert_text 'Inactive'
    assert_no_text 'Balance threshold'
  end

  def test_hide_details_when_a_user_never_provided_them
    @registrar.subscription_billing.destroy!
    visit registrar_settings_root_url
    assert_text 'Inactive'
    assert_no_text 'Balance threshold'
  end

  def test_update
    @registrar.subscription_billing.update!(low_balance_threshold: 1, top_up_amount: 10)

    visit registrar_settings_root_url
    click_link_or_button 'Edit'
    check 'Active'
    fill_in 'Low balance threshold', with: '100'
    fill_in 'Top-up amount', with: '1000'
    click_on 'Update'
    registrars(:bestnames).subscription_billing.reload

    assert_equal Money.from_amount(100), @registrar.subscription_billing.low_balance_threshold
    assert_equal Money.from_amount(1000), @registrar.subscription_billing.top_up_amount
    assert_current_path registrar_settings_root_path
    assert_text 'Subscription is updated'
  end
end
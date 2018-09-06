require 'test_helper'

class SettingsTest < ActionDispatch::IntegrationTest
  def test_subscription_billing_can_be_enabled
    assert Billing::Subscription.enabled?
  end
end
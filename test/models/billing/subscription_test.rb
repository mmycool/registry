require 'test_helper'

class BillingSubscriptionTest < ActiveSupport::TestCase
  setup do
    @subscription = billing_subscriptions(:one)
  end

  teardown do
    Billing::Subscription.disable
  end

  def test_feature_is_disabled_by_default
    assert Billing::Subscription.disabled?
  end

  def test_enable_feature
    Billing::Subscription.enable
    assert Billing::Subscription.enabled?
  end

  def test_disable_feature
    Billing::Subscription.disable
    assert Billing::Subscription.disabled?
  end

  def test_fixture_is_valid
    assert @subscription.valid?
  end

  def test_invalid_without_low_balance_threshold
    @subscription.low_balance_threshold = ''
    assert @subscription.invalid?
  end

  def test_low_balance_threshold_range_validation
    @subscription.low_balance_threshold = -1
    assert @subscription.invalid?

    @subscription.low_balance_threshold = 0
    assert @subscription.valid?

    @subscription.low_balance_threshold = 0.01
    assert @subscription.valid?
  end

  def test_fractional_low_balance_threshold
    @subscription.low_balance_threshold = 0.01
    @subscription.save!
    assert Money.from_amount(0.01), @subscription.low_balance_threshold
  end

  def test_invalid_without_top_up_amount
    @subscription.top_up_amount = ''
    assert @subscription.invalid?
  end

  def test_top_up_amount_range_validation
    @subscription.top_up_amount = -1
    assert @subscription.invalid?

    @subscription.top_up_amount = 0
    assert @subscription.invalid?

    @subscription.top_up_amount = 0.01
    assert @subscription.valid?
  end

  def test_fractional_top_up_amount
    @subscription.top_up_amount = 0.01
    @subscription.save!
    assert Money.from_amount(0.01), @subscription.top_up_amount
  end

  def test_active
    @subscription.active = false
    assert_not @subscription.active?

    @subscription.active = true
    assert @subscription.active?
  end

  def test_inactive
    @subscription.active = true
    assert_not @subscription.inactive?

    @subscription.active = false
    assert @subscription.inactive?
  end
end
require 'test_helper'

class DomainRenewableTest < ActiveSupport::TestCase
  def setup
    @domain = domains(:shop)
  end

  def test_renew_for_default_period
    assert_changes -> { @domain.valid_to }, from: '2010-07-05'.in_time_zone,
                   to: '2011-07-05'.in_time_zone do
      @domain.renew_for_default_period
      @domain.reload
    end
    assert_nil @domain.outzone_at
    assert_nil @domain.delete_at
  end

  def test_renew_for_specified_period
    assert_changes -> { @domain.valid_to }, from: '2010-07-05'.in_time_zone,
                   to: '2010-08-05'.in_time_zone do
      @domain.renew_for(1, 'm')
      @domain.reload
    end
    assert_nil @domain.outzone_at
    assert_nil @domain.delete_at
  end

  def test_can_be_renewed_any_time_when_pre_expiry_renew_period_is_disabled
    travel_to Time.zone.parse('2010-07-01')
    Setting.days_to_renew_domain_before_expire = 0
    @domain.valid_to = Time.zone.parse('2010-07-31')
    @domain.renew_for(1, 'm')
    assert_equal Time.zone.parse('2010-08-31'), @domain.valid_to
  end

  def test_can_be_renewed_within_pre_expiry_renew_period
    travel_to Time.zone.parse('2010-07-05')
    Setting.days_to_renew_domain_before_expire = 1
    @domain.valid_to = Time.zone.parse('2010-07-06')
    @domain.renew_for(1, 'm')
    assert_equal Time.zone.parse('2010-08-06'), @domain.valid_to
  end

  def test_cannot_be_renewed_outside_of_pre_expiry_renew_period
    travel_to Time.zone.parse('2010-07-03 23:59:59')
    Setting.days_to_renew_domain_before_expire = 1
    @domain.valid_to = Time.zone.parse('2010-07-06')

    assert_no_changes -> { @domain.valid_to } do
      @domain.renew_for(1, 'm')
    end
  end
end

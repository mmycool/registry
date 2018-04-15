require 'test_helper'

class DomainRenewableTest < ActiveSupport::TestCase
  setup do
    @domain = domains(:shop)
    @original_days_to_renew_domain_before_expire = Setting.days_to_renew_domain_before_expire
  end

  teardown do
    Setting.days_to_renew_domain_before_expire = @original_days_to_renew_domain_before_expire
  end

  def test_default_period
    @domain.valid_to = Time.zone.parse('2010-07-05')
    @domain.renew
    @domain.reload
    assert_equal Time.zone.parse('2011-07-05'), @domain.valid_to
  end

  def test_given_validity_period
    @domain.valid_to = Time.zone.parse('2010-07-05')
    @domain.renew(1.month)
    @domain.reload
    assert_equal Time.zone.parse('2010-08-05'), @domain.valid_to
  end

  def test_unsuspend
    @domain.outzone_at = '2010-07-05'
    @domain.statuses << DomainStatus::SERVER_HOLD
    @domain.renew
    @domain.reload
    assert @domain.unsuspended?
    assert_nil @domain.outzone_at
  end

  def test_unexpire
    @domain.delete_at = '2010-07-05'
    @domain.statuses << DomainStatus::EXPIRED
    @domain.renew
    @domain.reload
    refute_includes @domain.statuses, DomainStatus::EXPIRED
    assert_nil @domain.delete_at
  end

  def test_renew_any_time_when_pre_expiry_period_is_disabled
    travel_to Time.zone.parse('2010-07-01')
    Setting.days_to_renew_domain_before_expire = 0
    @domain.valid_to = Time.zone.parse('2010-07-31')
    @domain.renew(1.month)
    assert_equal Time.zone.parse('2010-08-31'), @domain.valid_to
  end

  def test_renew_within_pre_expiry_period
    travel_to Time.zone.parse('2010-07-05')
    Setting.days_to_renew_domain_before_expire = 1
    @domain.valid_to = Time.zone.parse('2010-07-06')
    @domain.renew(1.month)
    assert_equal Time.zone.parse('2010-08-06'), @domain.valid_to
  end

  def test_cannot_be_renewed_before_pre_expiry_period
    travel_to Time.zone.parse('2010-07-03 23:59:59')
    Setting.days_to_renew_domain_before_expire = 1
    @domain.valid_to = Time.zone.parse('2010-07-06')

    assert_no_changes -> { @domain.valid_to } do
      @domain.renew
    end
    assert_includes @domain.errors.full_messages, 'Domain cannot be renewed before pre-expiry' \
    ' period'
  end

  def test_discarded_domain_cannot_be_renewed
    domain = domains(:discarded)
    assert_no_changes -> { domain.valid_to } do
      domain.renew
    end
    assert_includes domain.errors.full_messages, 'Discarded domain cannot be renewed'
  end

  def test_domain_with_pending_actions_cannot_be_renewed
    @domain.statuses << DomainStatus::PENDING_RENEW
    assert_no_changes -> { @domain.valid_to } do
      @domain.renew
    end
    assert_includes @domain.errors.full_messages, 'Domain cannot be renewed because of pending' \
      ' action'
  end

  def test_registration_period_does_not_exceed_absolute_maximum
    travel_to Time.zone.parse('2010-07-05')
    @domain.valid_to = Time.zone.parse('2020-06-05')
    @domain.renew(1.month)
    @domain.reload
    assert_equal Time.zone.parse('2020-07-05'), @domain.valid_to
  end

  def test_registration_period_cannot_exceed_absolute_maximum
    travel_to Time.zone.parse('2010-07-05')
    @domain.valid_to = '2020-07-05'
    assert_no_changes -> { @domain.valid_to } do
      @domain.renew(1.month)
    end
    assert_includes @domain.errors.full_messages, 'Registration period cannot exceed 10 years'
  end
end

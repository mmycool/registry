module Concerns::Domain::Renewable
  extend ActiveSupport::Concern

  class_methods do
    def reg_period_abs_max
      # Between the current date and the current expiration date; Defined by ICANN
      10.years
    end
  end

  def renew(period = 1.year)
    @is_renewal = true

    if action_pending?
      errors.add(:base, :action_pending)
      return false
    end

    if discarded?
      errors.add(:base, :discarded_domain_cannot_be_renewed)
      return false
    end

    if pre_expiry_renew_period_enabled?
      unless pre_expiry_renew_period_started?
        errors.add(:base, :before_pre_expiry_period)
        return false
      end
    end

    if reg_period_exceeds_abs_max?(period)
      errors.add(:base, :reg_period_exceeds_abs_max)
      return false
    end

    self.valid_to += period
    self.period = period.parts.first.second
    self.period_unit = period.parts.first.first[0]

    unsuspend
    unexpire
    save
  end

  private

  def reg_period_exceeds_abs_max?(period)
    (valid_to + period) > (Time.zone.now + self.class.reg_period_abs_max)
  end

  def action_pending?
    (statuses & [DomainStatus::PENDING_RENEW,
                 DomainStatus::PENDING_TRANSFER,
                 DomainStatus::PENDING_DELETE,
                 DomainStatus::PENDING_UPDATE,
                 DomainStatus::PENDING_DELETE_CONFIRMATION]).any?
  end

  def pre_expiry_renew_period_enabled?
    pre_expiry_renew_period_days_before_type_cast.nonzero?
  end

  def pre_expiry_renew_period_started?
    Time.zone.now >= valid_to.ago(pre_expiry_renew_period_days_before_type_cast.days)
  end

  def pre_expiry_renew_period_days_before_type_cast
    Setting.days_to_renew_domain_before_expire.to_i
  end
end

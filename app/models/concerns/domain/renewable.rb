module Concerns::Domain::Renewable
  extend ActiveSupport::Concern

  def renew_for_default_period
    renew_for(1, 'y')
  end

  def renew_for(period, unit)
    @is_renewal = true

    period = period.to_i
    plural_period_unit_name = (unit == 'm' ? 'months' : 'years').to_sym
    renewed_expire_time = valid_to.advance(plural_period_unit_name => period.to_i)

    period_number, period_unit = Billing::Price.maximum(:duration).split
    max_reg_time = (period_number.to_i.public_send(period_unit) + 1.year).from_now

    if renewed_expire_time >= max_reg_time
      add_epp_error('2105', nil, nil, I18n.t('epp.domains.object_is_not_eligible_for_renewal',
                                             max_date: max_reg_time.to_date.to_s(:db)))
      return false if errors.any?
    end

    self.expire_time = renewed_expire_time
    self.outzone_at = nil
    self.delete_at = nil
    self.period = period
    self.period_unit = unit

    statuses.delete(DomainStatus::SERVER_HOLD)
    statuses.delete(DomainStatus::EXPIRED)
    statuses.delete(DomainStatus::SERVER_UPDATE_PROHIBITED)

    save
  end

  def non_renewable?
    !renewable?
  end

  private

  def add_epp_error(code, obj, val, msg)
    errors[:epp_errors] ||= []
    t = errors.generate_message(*msg) if msg.is_a?(Array)
    t = msg if msg.is_a?(String)
    err = { code: code, msg: t }
    err[:value] = { val: val, obj: obj } if val.present?
    errors[:epp_errors] << err
  end

  def renewable?
    if pre_expiry_renew_period_enabled?
      return false unless pre_expiry_renew_period_started?
    end

    return false if statuses.include_any?(DomainStatus::DELETE_CANDIDATE, DomainStatus::PENDING_RENEW,
                                          DomainStatus::PENDING_TRANSFER, DomainStatus::PENDING_DELETE,
                                          DomainStatus::PENDING_UPDATE, DomainStatus::PENDING_DELETE_CONFIRMATION)
    true
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

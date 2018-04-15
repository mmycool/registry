module Concerns::Domain::Suspendable
  extend ActiveSupport::Concern

  def unsuspended?
    statuses.exclude?(DomainStatus::SERVER_HOLD)
  end

  private

  def suspend
    statuses << DomainStatus::SERVER_HOLD
    self.outzone_at = Time.zone.now
  end

  def unsuspend
    statuses.delete(DomainStatus::SERVER_HOLD)
    self.outzone_at = nil
  end
end

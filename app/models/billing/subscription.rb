module Billing
  class Subscription < ActiveRecord::Base
    self.table_name = 'billing_subscriptions'

    belongs_to :registrar

    validates :low_balance_threshold, numericality: { greater_than_or_equal_to: 0 }
    validates :top_up_amount, numericality: { greater_than: 0 }

    monetize :low_balance_threshold_cents
    monetize :top_up_amount_cents

    @enabled = (ENV['subscription_billing'] == 'true')

    def self.enable
      @enabled = true
    end

    def self.disable
      @enabled = false
    end

    def self.enabled?
      @enabled
    end

    def self.disabled?
      !@enabled
    end

    def inactive?
      !active?
    end
  end
end
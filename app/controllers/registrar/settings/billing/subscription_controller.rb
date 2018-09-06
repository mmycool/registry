class Registrar
  module Settings
    module Billing
      class SubscriptionController < BaseController
        skip_authorization_check

        def edit
          @subscription = subscription || ::Billing::Subscription.new
        end

        def update
          @subscription = subscription || current_registrar_user.registrar.build_subscription_billing
          @subscription.attributes = subscription_params
          @subscription.save!
          redirect_to registrar_settings_root_url, notice: t('.updated')
        end

        private

        def subscription
          current_registrar_user.registrar.subscription_billing
        end

        def subscription_params
          params.require(:subscription).permit(:active, :low_balance_threshold, :top_up_amount)
        end
      end
    end
  end
end
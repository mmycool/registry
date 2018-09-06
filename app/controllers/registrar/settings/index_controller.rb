class Registrar
  module Settings
    class IndexController < BaseController
      skip_authorization_check

      def index
        @subscription = current_registrar_user.registrar.subscription_billing
      end
    end
  end
end
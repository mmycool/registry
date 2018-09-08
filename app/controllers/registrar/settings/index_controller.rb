class Registrar
  module Settings
    class IndexController < BaseController
      skip_authorization_check

      def show
        @registrar = current_registrar_user.registrar
      end
    end
  end
end
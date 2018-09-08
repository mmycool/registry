class Registrar
  module Settings
    class AutoInvoiceController < BaseController
      skip_authorization_check

      def edit
        @registrar = registrar
      end

      def update
        registrar.update!(registrar_params)
        redirect_to registrar_settings_root_url, notice: t('.updated')
      end

      private

      def registrar
        current_registrar_user.registrar
      end

      def registrar_params
        params.require(:registrar).permit(:auto_invoice, :low_balance_threshold, :top_up_amount)
      end
    end
  end
end
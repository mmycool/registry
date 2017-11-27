require 'test_helper'

class ShowRegistrarTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  def setup
    login_as users(:admin)
    @registrar = registrars(:complete)
    visit admin_registrar_path(@registrar)
  end

  def test_accounting_customer_code
    assert_text 'ACCOUNT001'
  end

  def test_vat_no
    assert_text 'US12345'
  end

  def test_vat_rate
    assert_text number_to_percentage(@registrar.vat_rate, precision: 1)
  end
end

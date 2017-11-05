require 'test_helper'

class DepositsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login_as create(:api_user)
  end

  def test_creates_new_invoice
    assert_difference -> { Invoice.count } do
      post registrar_deposits_path, deposit: { amount: 1 }
    end
  end

  def test_redirects_to_newly_created_invoice
    post registrar_deposits_path, deposit: { amount: 1 }
    assert_redirected_to registrar_invoice_url(Invoice.last)
  end
end

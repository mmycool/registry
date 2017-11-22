require 'test_helper'

class TopUpTest < ActionDispatch::IntegrationTest
  def setup
    login_as users(:api)
  end

  def test_adds_deposit
    visit registrar_invoices_path
    click_link_or_button 'Add deposit'
    click_link_or_button 'Add'

    assert_text t('registrar.deposits.create.created')
  end
end

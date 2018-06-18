require 'test_helper'

class RegistrarAreaLogoutTest < ActionDispatch::IntegrationTest
  def setup
    login_as users(:api_bestnames)
  end

  def test_logout
    visit registrar_root_url
    click_on 'Log out'

    assert_text 'Signed out successfully'
    assert_current_path registrar_login_path
  end
end
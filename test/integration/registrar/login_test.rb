require 'test_helper'

class RegistrarAreaLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:api_bestnames)
  end

  def test_correct_username_and_password
    visit registrar_login_url
    fill_in 'depp_user_tag', with: @user.username
    fill_in 'depp_user_password', with: 'testtest'
    click_button 'Login'

    assert_text 'Log out'
    assert_current_path registrar_root_path
  end

  def test_wrong_password
    visit registrar_login_url
    fill_in 'depp_user_tag', with: @user.username
    fill_in 'depp_user_password', with: 'wrong'
    click_button 'Login'

    assert_text 'No such user'
  end

  def test_inactive_user
    @user.update!(active: false)

    visit registrar_login_url
    fill_in 'depp_user_tag', with: @user.username
    fill_in 'depp_user_password', with: 'testtest'
    click_button 'Login'

    assert_text 'User is not active'
  end
end
require 'test_helper'

class EditZoneTest < ActionDispatch::IntegrationTest
  def setup
    login_as create(:admin_user)
  end

  def test_updates_zone
    create(:zone)

    visit admin_zones_path
    click_link_or_button 'admin-edit-zone-btn'
    click_link_or_button t('admin.dns.zones.form.update_btn')

    assert_text t('admin.dns.zones.update.updated')
  end
end

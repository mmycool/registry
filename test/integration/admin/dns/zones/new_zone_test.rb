require 'test_helper'

class NewZoneTest < ActionDispatch::IntegrationTest
  def setup
    login_as create(:admin_user)
  end

  def test_creates_new_zone_with_required_fields_filled
    visit admin_zones_path
    click_link_or_button t('admin.dns.zones.index.new_btn')

    fill_in 'zone_origin', with: 'test'
    fill_in 'zone_ttl', with: '1'
    fill_in 'zone_refresh', with: '1'
    fill_in 'zone_retry', with: '1'
    fill_in 'zone_expire', with: '1'
    fill_in 'zone_minimum_ttl', with: '1'
    fill_in 'zone_email', with: 'test@test.com'
    fill_in 'zone_master_nameserver', with: 'test.test'
    click_link_or_button t('admin.dns.zones.form.create_btn')

    assert_text t('admin.dns.zones.create.created')
  end
end

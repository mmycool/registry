require 'test_helper'

class ZonesControllerTest < ActionDispatch::IntegrationTest
  def setup
    login_as create(:admin_user)
  end

  def test_updates_ns_records
    zone = create(:zone, ns_records: 'test')

    patch admin_zone_path(zone), zone: attributes_for(:zone, ns_records: 'new-ns-records')
    zone.reload

    assert_equal 'new-ns-records', zone.ns_records
  end

  def test_updates_a_records
    zone = create(:zone, a_records: 'a-records')

    patch admin_zone_path(zone), zone: attributes_for(:zone, a_records: 'new-a-records')
    zone.reload

    assert_equal 'new-a-records', zone.a_records
  end

  def test_updates_a4_records
    zone = create(:zone, a4_records: 'a4-records')

    patch admin_zone_path(zone), zone: attributes_for(:zone, a4_records: 'new-a4-records')
    zone.reload

    assert_equal 'new-a4-records', zone.a4_records
  end

  def test_redirects_to_zone_list
    zone = create(:zone)
    patch admin_zone_path(zone), zone: attributes_for(:zone)
    assert_redirected_to admin_zones_url
  end
end

require 'test_helper'

class ZonesControllerTest < ActionDispatch::IntegrationTest
  def setup
    login_as create(:admin_user)
  end

  def test_creates_new_zone_with_required_attributes
    assert_difference -> { DNS::Zone.count } do
      post admin_zones_path, zone: attributes_for(:zone)
    end
  end

  def test_redirects_to_newly_created_zone
    post admin_zones_path, zone: attributes_for(:zone)
    assert_redirected_to admin_zones_url
  end
end

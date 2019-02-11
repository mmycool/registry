require 'test_helper'

class RegistrantUserTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:registrant)
  end

  def teardown
    super
  end

  def test_administered_domains_returns_a_list_of_domains
    domain_names = @user.administered_domains.pluck(:name)
    assert_equal(3, domain_names.length)

    # User is a tech contact for the domain.
    refute(domain_names.include?('library.test'))
  end

  def test_ident_and_country_code_helper_methods
    assert_equal('1234', @user.ident)
    assert_equal('US', @user.country_code)
  end

  def test_first_name_from_username
    user = RegistrantUser.new(username: 'John Doe')
    assert_equal 'John', user.first_name
  end

  def test_last_name_from_username
    user = RegistrantUser.new(username: 'John Doe')
    assert_equal 'Doe', user.last_name
  end

  def test_returns_contacts
    Contact.stub(:find_by_registrant_user, %w(john jane)) do
      assert_equal %w(john jane), @user.contacts
    end
  end

  def test_returns_domains
    Domain.stub(:find_by_registrant_user, %w(shop airport)) do
      assert_equal %w(shop airport), @user.domains
    end
  end
end

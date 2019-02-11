require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  setup do
    @domain = domains(:shop)
  end

  def test_valid_fixture_is_valid
    assert @domain.valid?
  end

  def test_invalid_fixture_is_invalid
    assert domains(:invalid).invalid?
  end

  def test_domain_name
    domain = Domain.new(name: 'shop.test')
    assert_equal 'shop.test', domain.domain_name.to_s
  end

  def test_find_by_registrant_user_returns_domains_by_registrant
    assert_equal contacts(:john).becomes(Registrant), @domain.registrant
    registrant_user = RegistrantUser.new

    registrant_user.stub(:contacts, [contacts(:john)]) do
      assert_includes Domain.find_by_registrant_user(registrant_user), @domain
    end
  end

  def test_find_by_registrant_user_returns_domains_by_contact
    assert_includes @domain.contacts, contacts(:jane)
    registrant_user = RegistrantUser.new

    registrant_user.stub(:contacts, [contacts(:jane)]) do
      assert_includes Domain.find_by_registrant_user(registrant_user), @domain
    end
  end
end

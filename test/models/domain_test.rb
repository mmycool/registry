require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  def setup
    @domain = domains(:shop)
  end

  def test_valid_fixture_is_valid
    assert @domain.valid?
  end

  def test_invalid_fixture_is_invalid
    assert domains(:invalid).invalid?
  end

  def test_invalid_when_registrant_is_invalid
    @domain.registrant = contacts(:invalid).becomes(Registrant)
    assert @domain.invalid?
    assert_equal ['Registrant is invalid'], @domain.errors.full_messages
  end

  def test_invalid_when_admin_contact_is_invalid
    @domain.domain_contacts << domain_contacts(:invalid_invalid_admin)
    assert @domain.invalid?
    assert_equal ['Contacts are invalid'], @domain.errors.full_messages
  end

  def test_invalid_when_tech_contact_is_invalid
    @domain.domain_contacts << domain_contacts(:invalid_invalid_tech)
    assert @domain.invalid?
    assert_equal ['Contacts are invalid'], @domain.errors.full_messages
  end
end

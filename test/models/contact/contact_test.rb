require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  setup do
    @contact = contacts(:john)
  end

  def test_valid_fixture_is_valid
    assert @contact.valid?
  end

  def test_invalid_fixture_is_invalid
    assert contacts(:invalid).invalid?
  end

  def test_in_use_if_acts_as_a_registrant
    DomainContact.delete_all
    assert @contact.in_use?
  end

  def test_in_use_if_acts_as_a_domain_contact
    Domain.update_all(registrant_id: contacts(:william))
    assert @contact.in_use?
  end

  def test_not_in_use_if_acts_as_neither_registrant_nor_domain_contact
    refute contacts(:not_in_use).in_use?
  end

  def test_managed_when_identity_codes_match
    contact = Contact.new(ident: '1234')
    user = RegistrantUser.new(registrant_ident: 'US-1234')
    assert contact.managed_by?(user)
  end

  def test_unmanaged_when_identity_codes_do_not_match
    contact = Contact.new(ident: '1234')
    user = RegistrantUser.new(registrant_ident: 'US-12345')
    assert_not contact.managed_by?(user)
  end
end

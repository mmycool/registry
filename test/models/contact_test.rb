require 'test_helper'

class RegistrantUserDouble
  def ident
    '1234'
  end

  def country_code
    'US'
  end
end

class RegistrantUserDoubleTest < ActiveSupport::TestCase
  def setup
    @registrant_user = RegistrantUserDouble.new
  end

  def test_implements_registrant_user_interface
    assert_respond_to @registrant_user, :ident
    assert_respond_to @registrant_user, :country_code
  end
end

class CompanyRegisterClientDouble
  Company = Struct.new(:registration_number)

  def representation_rights(citizen_personal_code:, citizen_country_code:)
    [Company.new(12345)]
  end
end

class CompanyRegisterClientDoubleTest < ActiveSupport::TestCase
  def setup
    @client = CompanyRegister::Client.new
  end

  def test_implements_registrant_user_interface
    assert_respond_to @client, :representation_rights
  end
end

class ContactTest < ActiveSupport::TestCase
  setup do
    @contact = contacts(:john)
  end

  def test_valid_fixture
    assert @contact.valid?, proc { @contact.errors.full_messages }
  end

  def test_private_entity
    assert_equal 'priv', Contact::PRIV
  end

  def test_invalid_without_email
    @contact.email = ''
    assert @contact.invalid?
  end

  def test_email_format_validation
    @contact.email = 'invalid'
    assert @contact.invalid?

    @contact.email = 'test@bestmail.test'
    assert @contact.valid?
  end

  def test_invalid_without_phone
    @contact.email = ''
    assert @contact.invalid?
  end

  def test_phone_format_validation
    @contact.phone = '+123.'
    assert @contact.invalid?

    @contact.phone = '+123.4'
    assert @contact.valid?
  end

  def test_address
    address = Contact::Address.new('new street', '83746', 'new city', 'new state', 'EE')
    @contact.address = address
    @contact.save!
    @contact.reload

    assert_equal 'new street', @contact.street
    assert_equal '83746', @contact.zip
    assert_equal 'new city', @contact.city
    assert_equal 'new state', @contact.state
    assert_equal 'EE', @contact.country_code
    assert_equal address, @contact.address
  end

  def test_find_by_registrant_user_returns_direct_contacts
    assert_equal Contact::PRIV, @contact.ident_type
    assert_equal '1234', @contact.ident
    assert_equal 'US', @contact.ident_country_code

    CompanyRegister::Client.stub(:new, CompanyRegisterClientDouble.new) do
      assert_equal [@contact], Contact.find_by_registrant_user(RegistrantUserDouble.new)
    end
  end

  def test_find_by_registrant_user_returns_indirect_contacts
    @contact.update!(ident_type: Contact::ORG,
                     ident: '12345',
                     ident_country_code: 'US')

    CompanyRegister::Client.stub(:new, CompanyRegisterClientDouble.new) do
      assert_equal [@contact], Contact.find_by_registrant_user(RegistrantUserDouble.new)
    end
  end

  def test_find_by_registrant_user_does_not_return_unassociated_contacts
    @contact.update!(ident_type: Contact::PRIV,
                     ident: '123',
                     ident_country_code: 'US')

    CompanyRegister::Client.stub(:new, CompanyRegisterClientDouble.new) do
      assert_empty Contact.find_by_registrant_user(RegistrantUserDouble.new)
    end
  end
end

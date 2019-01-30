require 'test_helper'

class RegistrantUserTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:registrant)
  end

  def teardown
    super
  end

  def test_domains_returns_an_list_of_distinct_domains_associated_with_a_specific_id_code
    domain_names = @user.domains.pluck(:name)
    assert_equal(4, domain_names.length)

    # User is a registrant, but not a contact for the domain. Should be included in the list.
    assert(domain_names.include?('shop.test'))
  end

  def test_administered_domains_returns_a_list_of_domains
    domain_names = @user.administered_domains.pluck(:name)
    assert_equal(3, domain_names.length)

    # User is a tech contact for the domain.
    refute(domain_names.include?('library.test'))
  end

  def test_contacts_returns_an_list_of_contacts_associated_with_a_specific_id_code
    assert_equal(1, @user.contacts.count)
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

  def test_finding_by_id_card_creates_new_user_upon_first_sign_in
    assert_not_equal 'US-5555', @user.registrant_ident
    id_card = IDCard.new
    id_card.first_name = 'John'
    id_card.last_name = 'Doe'
    id_card.personal_code = '5555'
    id_card.country_code = 'US'

    assert_difference 'RegistrantUser.count' do
      RegistrantUser.find_by_id_card(id_card)
    end

    user = RegistrantUser.last
    assert_equal 'US-5555', user.registrant_ident
    assert_equal 'John Doe', user.username
  end

  def test_finding_by_id_card_reuses_existing_user_upon_subsequent_id_card_sign_ins
    @user.update!(registrant_ident: 'US-5555')
    id_card = IDCard.new
    id_card.personal_code = '5555'
    id_card.country_code = 'US'

    assert_no_difference 'RegistrantUser.count' do
      RegistrantUser.find_by_id_card(id_card)
    end
  end
end

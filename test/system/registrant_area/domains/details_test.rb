require 'test_helper'

class RegistrantAreaDomainDetailsTest < ApplicationSystemTestCase
  setup do
    sign_in users(:registrant)
    @domain = domains(:shop)

    Setting.days_to_keep_business_registry_cache = 1
    travel_to Time.zone.parse('2010-07-05')
  end

  def test_general_data
    visit registrant_domain_url(@domain)
    assert_text 'Name shop.test'
    assert_text "Registered at #{l Time.zone.parse('2010-07-04')}"
    assert_link 'Best Names', href: registrant_registrar_path(@domain.registrar)

    assert_text 'Transfer code'
    assert_css('[value="65078d5"]')

    assert_text "Valid to #{l Time.zone.parse('2010-07-05')}"
    assert_text "Outzone at #{l Time.zone.parse('2010-07-06')}"
    assert_text "Delete at #{l Time.zone.parse('2010-07-07')}"
    assert_text "Force delete at #{l Time.zone.parse('2010-07-08')}"
  end

  def test_registrant
    visit registrant_domain_url(@domain)
    assert_text 'Name John'
    assert_text 'Code john-001'
    assert_text 'Ident 1234'
    assert_text 'Email john@inbox.test'
    assert_text 'Phone +555.555'
    assert_link 'View details', href: registrant_domain_contact_path(@domain, @domain.registrant)
  end

  def test_admin_contacts
    visit registrant_domain_url(@domain)

    within('.admin-domain-contacts') do
      assert_link 'Jane', href: registrant_domain_contact_path(@domain, contacts(:jane))
      assert_text 'jane-001'
      assert_text 'jane@mail.test'
      assert_css '.admin-domain-contact', count: 1
    end
  end

  def test_tech_contacts
    visit registrant_domain_url(@domain)

    within('.tech-domain-contacts') do
      assert_link 'William', href: registrant_domain_contact_path(@domain, contacts(:william))
      assert_text 'william-001'
      assert_text 'william@inbox.test'
      assert_css '.tech-domain-contact', count: 2
    end
  end
end
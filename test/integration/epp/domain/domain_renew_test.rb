require 'test_helper'

class EppDomainRenewTest < ActionDispatch::IntegrationTest
  self.use_transactional_fixtures = false

  setup do
    @domain = domains(:shop)
    travel_to Time.zone.parse('2010-07-05')
    @original_days_to_renew_domain_before_expire = Setting.days_to_renew_domain_before_expire
  end

  teardown do
    Setting.days_to_renew_domain_before_expire = @original_days_to_renew_domain_before_expire
  end

  def test_charge_a_registrar
    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>shop.test</domain:name>
              <domain:curExpDate>2010-07-05</domain:curExpDate>
              <domain:period unit="m">1</domain:period>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    assert_equal 99, registrars(:bestnames).balance
  end

  def test_return_details_of_the_operation
    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>shop.test</domain:name>
              <domain:curExpDate>2010-07-05</domain:curExpDate>
              <domain:period unit="m">1</domain:period>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    assert_equal 'shop.test',
                 Nokogiri::XML(response.body).xpath('//domain:renData/domain:name',
                                                    'domain' => 'https://epp.tld.ee/schema/domain-eis-1.0.xsd').text
    assert_equal Time.zone.parse('2010-08-05').iso8601,
                 Nokogiri::XML(response.body).xpath('//domain:renData/domain:exDate', 'domain' =>
                   'https://epp.tld.ee/schema/domain-eis-1.0.xsd').text
  end

  def test_apply_default_period_when_one_is_not_provided
    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>shop.test</domain:name>
              <domain:curExpDate>2010-07-05</domain:curExpDate>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    assert_equal Time.zone.parse('2011-07-05'), @domain.expire_time
    assert_equal '1000', Nokogiri::XML(response.body).at_css('result')[:code],
                 Nokogiri::XML(response.body).css('result').text
    assert_equal 1, Nokogiri::XML(response.body).css('result').size
  end

  def test_insufficient_funds
    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>metro.test</domain:name>
              <domain:curExpDate>2010-07-05</domain:curExpDate>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    assert_no_changes -> { @domain.expire_time } do
      post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_goodnames'
    end

    assert_equal '2104', Nokogiri::XML(response.body).at_css('result')[:code],
                 Nokogiri::XML(response.body).css('result').text
  end

  def test_provided_expiry_date_must_match_actual_expiry_date_of_a_domain
    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>shop.test</domain:name>
              <domain:curExpDate>1970-01-01</domain:curExpDate>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    assert_no_changes -> { @domain.expire_time } do
      post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    end

    assert_equal '2306', Nokogiri::XML(response.body).at_css('result')[:code],
                 Nokogiri::XML(response.body).css('result').text
    assert_equal 'Given and current expire dates do not match',
                 Nokogiri::XML(response.body).at_css('result msg').text
  end

  def test_no_price
    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>shop.test</domain:name>
              <domain:curExpDate>2010-07-05</domain:curExpDate>
              <domain:period unit="m">99</domain:period>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    assert_no_changes -> { @domain.expire_time } do
      post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    end

    assert_equal '2104', Nokogiri::XML(response.body).at_css('result')[:code],
                 Nokogiri::XML(response.body).css('result').text
  end

  def test_invalid_domain_cannot_be_renewed
    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>invalid.test</domain:name>
              <domain:curExpDate>2010-07-05</domain:curExpDate>
              <domain:period unit="m">1</domain:period>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    assert_no_changes -> { domains(:invalid).valid_to } do
      post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    end
    assert_equal '2304', Nokogiri::XML(response.body).at_css('result')[:code],
                 Nokogiri::XML(response.body).css('result').text
  end

  def test_discarded_domain_cannot_be_renewed
    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>discarded.test</domain:name>
              <domain:curExpDate>2010-07-05</domain:curExpDate>
              <domain:period unit="m">1</domain:period>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    assert_no_changes -> { @domain.valid_to } do
      post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    end
    assert_equal '2105', Nokogiri::XML(response.body).at_css('result')[:code],
                 Nokogiri::XML(response.body).css('result').text
    assert_equal 'Object is not eligible for renewal: status deleteCandidate',
                 Nokogiri::XML(response.body).at_css('result msg').text
  end

  def test_domain_with_statuses_of_pending_class_cannot_be_renewed
    @domain.update!(statuses: [DomainStatus::PENDING_RENEW])

    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>shop.test</domain:name>
              <domain:curExpDate>2010-07-05</domain:curExpDate>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    assert_no_changes -> { @domain.valid_to } do
      post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    end
    assert_equal '2105', Nokogiri::XML(response.body).at_css('result')[:code],
                 Nokogiri::XML(response.body).css('result').text
    assert_equal 'Object is not eligible for renewal',
                 Nokogiri::XML(response.body).at_css('result msg').text
  end

  def test_maximum_registration_period_cannot_exceed_10_years
    travel_to Time.zone.parse('2010-07-05')
    @domain.update!(valid_to: '2020-07-05')

    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>shop.test</domain:name>
              <domain:curExpDate>2020-07-05</domain:curExpDate>
              <domain:period unit="m">1</domain:period>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    assert_no_changes -> { @domain.valid_to } do
      post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    end
    assert_equal '2105', Nokogiri::XML(response.body).at_css('result')[:code],
                 Nokogiri::XML(response.body).css('result').text
    assert_equal 'Object is not eligible for renewal; Expiration date must be before 2021-07-05',
                 Nokogiri::XML(response.body).at_css('result msg').text
  end

  def test_non_existent_domain
    request_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <renew>
            <domain:renew xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>non-existent.test</domain:name>
              <domain:curExpDate>2010-07-05</domain:curExpDate>
            </domain:renew>
          </renew>
        </command>
      </epp>
    XML

    post '/epp/command/renew', { frame: request_xml }, 'HTTP_COOKIE' => 'session=api_bestnames'
    assert_equal '2303', Nokogiri::XML(response.body).at_css('result')[:code],
                 Nokogiri::XML(response.body).css('result').text
  end
end

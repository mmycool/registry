require 'rails_helper'

RSpec.describe 'EPP domain:update' do
  let!(:domain) { create(:domain, name: 'test.com') }
  let!(:new_registrant) { create(:registrant, code: 'test') }

  before :example do
    sign_in_to_epp_area
  end

  context 'when domain is disputed' do
    let!(:dispute) { create(:dispute, domain: domain, password: 'test') }

    context 'when password is valid' do
      let(:request_xml) { <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
          <command>
            <update>
              <domain:update xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
                <domain:name>test.com</domain:name>
                  <domain:chg>
                    <domain:registrant>test</domain:registrant>
                  </domain:chg>
              </domain:update>
            </update>
            <extension>
              <eis:extdata xmlns:eis="https://epp.tld.ee/schema/eis-1.0.xsd">
                <eis:legalDocument type="pdf">#{valid_legal_document}</eis:legalDocument>
                <eis:reserved>
                  <eis:pw>test</eis:pw>
                </eis:reserved>
              </eis:extdata>
            </extension>
          </command>
        </epp>
      XML
      }

      it 'returns epp code of 1001' do
        post '/epp/command/update', frame: request_xml
        expect(response).to have_code_of(1001)
      end
    end

    context 'when password is invalid' do
      let(:request_xml) { <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
          <command>
            <update>
              <domain:update xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
                <domain:name>test.com</domain:name>
                  <domain:chg>
                    <domain:registrant>test</domain:registrant>
                  </domain:chg>
              </domain:update>
            </update>
            <extension>
              <eis:extdata xmlns:eis="https://epp.tld.ee/schema/eis-1.0.xsd">
                <eis:legalDocument type="pdf">#{valid_legal_document}</eis:legalDocument>
                <eis:reserved>
                  <eis:pw>invalid</eis:pw>
                </eis:reserved>
              </eis:extdata>
            </extension>
          </command>
        </epp>
      XML
      }

      it 'returns epp code of 2202' do
        post '/epp/command/update', frame: request_xml
        expect(response).to have_code_of(2202)
      end
    end

    context 'when password is absent' do
      let(:request_xml) { <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
          <command>
            <update>
              <domain:update xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
                <domain:name>test.com</domain:name>
                  <domain:chg>
                    <domain:registrant>test</domain:registrant>
                  </domain:chg>
              </domain:update>
            </update>
            <extension>
              <eis:extdata xmlns:eis="https://epp.tld.ee/schema/eis-1.0.xsd">
                <eis:legalDocument type="pdf">#{valid_legal_document}</eis:legalDocument>
              </eis:extdata>
            </extension>
          </command>
        </epp>
      XML
      }

      it 'returns epp code of 2003' do
        post '/epp/command/update', frame: request_xml
        expect(response).to have_code_of(2003)
      end
    end
  end

  context 'when domain is not disputed' do
    let(:request_xml) { <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <update>
            <domain:update xmlns:domain="https://epp.tld.ee/schema/domain-eis-1.0.xsd">
              <domain:name>test.com</domain:name>
                <domain:chg>
                  <domain:registrant>test</domain:registrant>
                </domain:chg>
            </domain:update>
          </update>
          <extension>
            <eis:extdata xmlns:eis="https://epp.tld.ee/schema/eis-1.0.xsd">
              <eis:legalDocument type="pdf">#{valid_legal_document}</eis:legalDocument>
            </eis:extdata>
          </extension>
        </command>
      </epp>
    XML
    }

    it 'returns epp code of 1001' do
      post '/epp/command/update', frame: request_xml
      expect(response).to have_code_of(1001)
    end
  end
end
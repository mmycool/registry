require 'rails_helper'

describe Repp::ContactV1 do
  let(:api_user) { Fabricate(:api_user) }

  before(:each) { create_settings }

  describe 'GET /repp/v1/contacts' do
    it 'returns contacts of the current registrar' do
      Fabricate.times(2, :contact, registrar: api_user.registrar)
      Fabricate.times(2, :contact)

      get_with_auth '/repp/v1/contacts', {}, api_user
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      expect(body['total_pages']).to eq(1)

      # TODO: Maybe there is a way not to convert from and to json again
      expect(body['contacts'].to_json).to eq(api_user.registrar.contacts.to_json)

      log = ApiLog::ReppLog.first
      expect(log[:request_path]).to eq('/repp/v1/contacts')
      expect(log[:request_method]).to eq('GET')
      expect(log[:request_params]).to eq('{}')
      expect(log[:response].length).to be > 20
      expect(log[:response_code]).to eq('200')
      expect(log[:api_user_name]).to eq('gitlab')
      expect(log[:api_user_registrar]).to eq('Registrar OÜ')
      expect(log[:ip]).to eq('127.0.0.1')
    end
  end
end

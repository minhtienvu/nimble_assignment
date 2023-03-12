require 'rails_helper'

RSpec.describe GoogleApiHelper, type: :helper do
  describe '#google_api_key' do
    context 'get api key on Google' do
      it 'return google api key' do
        api_key = helper.google_api_key
        expect(api_key).to eq Rails.application.credentials.google_search_api[:api_key]
      end
    end
  end

  describe '#google_api_secret' do
    context 'get api secret on Google' do
      it 'return google api secret' do
        api_secret = helper.google_engine_id
        expect(api_secret).to eq Rails.application.credentials.google_search_api[:engine_id]
      end
    end
  end

  describe '#google_search_query' do
    context 'get search query on Google' do
      it 'return google search query' do
        search_query = helper.google_search_query('test')
        expect(search_query).to eq "#{GoogleApiHelper::CUSTOMER_SEARCH_API}/v1?key=#{helper.google_api_key}&cx=#{helper.google_engine_id}&q=test&fields=searchInformation"
      end
    end
  end
end

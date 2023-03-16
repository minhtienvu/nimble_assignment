require 'rails_helper'

RSpec.describe Api::V1::External::StatisticsController, type: :controller do
  include GoogleApiHelper
  render_views

  shared_examples 'authorization_empty' do
    before do
      request.headers['Authorization'] = nil
    end
  end

  shared_examples 'authorization_valid' do
    let(:user) { create(:user) }
    let(:payload) do
      {
        user_id: user.id,
        exp: 10.minutes.from_now.to_i
      }
    end
    let(:token) { JWT.encode(payload, Constants::SECRET_KEY) }

    before do
      request.headers['Authorization'] = token
    end
  end

  describe 'validations' do
    context 'Do not authenticate' do
      include_examples 'authorization_empty'

      it 'return error' do
        get :index, format: :json
        body = JSON.parse(response.body)
        expect(body['error']).to eq(Constants::JSON_WEB_TOKEN[:permission_denied])
      end
    end

    context 'Authenticate successfully' do
      include_examples 'authorization_valid'

      it 'return nil if authenticate successfully' do
        get :index, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #index' do
    include_examples 'authorization_valid'

    let!(:user) { create(:user) }
    let!(:file_upload) { create(:file_upload, user:) }
    let!(:statistic_1) { create(:statistic, keyword: 'Ruby', file_upload:, created_at: DateTime.current) }
    let!(:statistic_2) do
      create(:statistic, keyword: 'Python', file_upload:, created_at: DateTime.current - 1.days)
    end

    context 'return all statistics' do
      it 'return success response' do
        get :index, format: :json
        body = JSON.parse(response.body)
        expect(body['count']).to eq user.statistics.count
        expect(body['data']).to eq([statistic_2, statistic_1].as_json)
      end
    end

    context 'return statistics with limit' do
      it 'return success response' do
        get :index, params: { limit: 1 }, format: :json
        body = JSON.parse(response.body)
        expect(body['data']).to eq([statistic_2].as_json)
      end
    end

    context 'return statistics with offset' do
      it 'return success response' do
        get :index, params: { offset: 1 }, format: :json
        body = JSON.parse(response.body)
        expect(body['data']).to eq([statistic_1].as_json)
      end
    end
  end

  describe 'POST #upload' do
    include_examples 'authorization_valid'

    context 'return error if file is not csv format' do
      let!(:file_type_is_not_csv) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/file/search_keywords.txt'))
      end
      let!(:params) do
        {
          file: file_type_is_not_csv
        }
      end

      it 'return error' do
        post :upload, params: params, format: :json
        body = JSON.parse(response.body)
        expect(body['message']).to eq(Constants::GOOGLE_API_NOTICE[:file_type_is_not_csv])
      end
    end

    context 'return error if creating new statistics unsuccessfully' do
      let!(:file_over_data) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/file/search_keywords_over_data.csv'), 'text/csv')
      end
      let!(:params) do
        {
          file: file_over_data
        }
      end

      it 'return error if file is nil' do
        post :upload, params: { file: nil }, format: :json
        body = JSON.parse(response.body)
        expect(body['message']).to eq(Constants::GOOGLE_API_NOTICE[:file_required])
      end

      it 'return error if file data is not between 1 - 100' do
        post :upload, params: params, format: :json
        body = JSON.parse(response.body)
        expect(body['message']).to eq(Constants::GOOGLE_API_NOTICE[:file_data_size_invalid])
      end
    end

    context 'return success if create new statistics successfully' do
      let!(:file) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/file/search_1_keyword.csv'), 'text/csv')
      end
      let!(:params) do
        {
          file: file
        }
      end

      it 'return success response' do
        post :upload, params: params, format: :json

        expect(GoogleSearchWordsJob.jobs.count).to eq 1
        body = JSON.parse(response.body)
        expect(body['message']).to eq(Constants::GOOGLE_API_NOTICE[:file_is_processed])
      end
    end
  end
end

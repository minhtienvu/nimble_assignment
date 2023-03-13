require 'rails_helper'

RSpec.describe Api::V1::External::StatisticsController, type: :controller do
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

    context 'return error if creating new statistics unsuccessfully' do
      let!(:file_over_data) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/file/search_keywords_over_data.csv'))
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
      let!(:user) { create(:user) }
      let!(:file_upload) { create(:file_upload, user:) }
      let!(:statistic_1) { create(:statistic, keyword: 'Ruby', file_upload:, created_at: DateTime.current) }
      let!(:statistic_2) do
        create(:statistic, keyword: 'Python', file_upload:, created_at: DateTime.current - 1.days)
      end
      let!(:statistic_3) do
        create(:statistic, keyword: 'Javascript', file_upload:, created_at: DateTime.current - 1.days)
      end
      let!(:file) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/file/search_keywords_standard.csv'))
      end
      let!(:params) do
        {
          file: file
        }
      end

      before do
        allow(ActionDispatch::Http::UploadedFile).to receive(:new).and_return(file)
        allow_any_instance_of(GoogleSearcherServices).to receive(:search_words_from_file).with(file)
          .and_return(array_to_active_record_relation([statistic_1, statistic_2, statistic_3], Statistic))
      end

      it 'return success response' do
        post :upload, params: params, format: :json
        body = JSON.parse(response.body)
        expect(body['count']).to eq user.statistics.count
        expect(body['data']).to eq(user.statistics.order_by_id_desc.as_json)
      end
    end
  end
end

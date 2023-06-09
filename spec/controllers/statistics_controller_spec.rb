require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
  include GoogleApiHelper
  render_views

  describe 'validations' do
    context 'Do not authenticate' do
      it 'returns an error if the user is not authenticated' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'Authenticate' do
      login_user

      it 'return success if the user is authenticated' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #index' do
    login_user

    let!(:user) { subject.current_user }
    let!(:file_upload) { create(:file_upload, user:) }
    let!(:statistic_1) { create(:statistic, keyword: 'Ruby', file_upload:, created_at: DateTime.current) }
    let!(:statistic_2) do
      create(:statistic, keyword: 'Python', file_upload:, created_at: DateTime.current - 1.days)
    end
    let!(:params) do
      {
        search_keyword: statistic_1.keyword
      }
    end

    context 'return all statistics' do
      it 'return success response' do
        get :index
        expect(response).to render_template :index
        expect(assigns(:statistics)).to eq([statistic_2, statistic_1])
      end
    end

    context 'return statistics by searching keyword' do
      it 'return success response' do
        get :index, params: params
        expect(response).to render_template :index
        expect(assigns(:statistics)).to eq([statistic_1])
      end
    end
  end

  describe 'GET #new' do
    login_user

    context 'return a new statistic object' do
      it 'return success response' do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #create' do
    login_user

    context 'return error if file is not csv format' do
      let!(:file_type_is_not_csv) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/file/search_keywords.txt'))
      end
      let!(:params) do
        {
          statistic: {
            file: file_type_is_not_csv
          }
        }
      end

      it 'return error' do
        post :create, params: params
        expect(response).to redirect_to new_statistic_path
        expect(flash[:alert]).to eq(Constants::GOOGLE_API_NOTICE[:file_type_is_not_csv])
      end
    end

    context 'return error if creating new statistics unsuccessfully' do
      let!(:file_over_data) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/file/search_keywords_over_data.csv'), 'text/csv')
      end
      let!(:params) do
        {
          statistic: {
            file: file_over_data
          }
        }
      end

      it 'return error if file is nil' do
        post :create, params: { statistic: { file: nil } }
        expect(response).to redirect_to new_statistic_path
        expect(flash[:alert]).to eq(Constants::GOOGLE_API_NOTICE[:file_required])
      end

      it 'return error if file data is not between 1 - 100' do
        post(:create, params: params)
        expect(response).to redirect_to new_statistic_path
        expect(flash[:alert]).to eq(Constants::GOOGLE_API_NOTICE[:file_data_size_invalid])
      end
    end

    context 'return success if create new statistics successfully' do
      let!(:file) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/file/search_1_keyword.csv'), 'text/csv')
      end
      let!(:params) do
        {
          statistic: {
            file: file
          }
        }
      end

      it 'return success response' do
        post :create, params: params
        expect(GoogleSearchWordsJob.jobs.count).to eq 1
        expect(response).to redirect_to new_statistic_path
        expect(flash[:notice]).to eq(Constants::GOOGLE_API_NOTICE[:file_is_processed])
      end
    end
  end
end

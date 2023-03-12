require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
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

    context 'return error if creating new statistics unsuccessfully' do
      let!(:file_over_data) do
        Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/file/search_keywords_over_data.csv'))
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
        post(:create, params:)
        expect(response).to redirect_to new_statistic_path
        expect(flash[:alert]).to eq(Constants::GOOGLE_API_NOTICE[:file_data_size_invalid])
      end
    end

    context 'return success if create new statistics successfully' do
      let!(:user) { subject.current_user }
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
          statistic: {
            file: file
          }
        }
      end

      before do
        allow(ActionDispatch::Http::UploadedFile).to receive(:new).and_return(file)
        allow_any_instance_of(GoogleSearcherServices).to receive(:search_words_from_file).with(file)
          .and_return(array_to_active_record_relation([statistic_1, statistic_2, statistic_3], Statistic))
      end

      it 'return success response' do
        post :create, params: params
        expect(response).to redirect_to statistics_path
        expect(flash[:notice]).to eq(Constants::GOOGLE_API_NOTICE[:import_success])
        expect(assigns(:statistics).count).to eq(user.statistics.count)
      end
    end
  end
end

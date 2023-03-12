require 'rails_helper'

RSpec.describe Api::V1::External::AuthController, type: :controller do
  describe 'POST #login' do
    let!(:user) { create(:user) }

    context 'return authentication error' do
      let!(:invalid_params) do
        {
          email: user.email
        }
      end

      it 'return success response' do
        post :login, params: invalid_params
        body = JSON.parse(response.body)
        expect(body['message']).to eq Constants::JSON_WEB_TOKEN[:authorization_error]
      end
    end

    context 'return success response' do
      let!(:params) do
        {
          email: user.email,
          password: user.password
        }
      end

      it 'return a token' do
        post :login, params: params
        body = JSON.parse(response.body)
        expect(body['token']).to be_present
      end
    end
  end
end

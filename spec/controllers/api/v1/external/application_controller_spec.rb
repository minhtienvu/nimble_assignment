require 'rails_helper'

RSpec.describe Api::V1::External::ApplicationController, type: :controller do
  extend ActiveSupport::Concern

  shared_examples 'authorization_empty' do
    controller do
      def index
        render json: {}
      end
    end

    before do
      request.headers['Authorization'] = nil
      get :index
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
    controller do
      def index
        render json: {}
      end
    end

    before do
      request.headers['Authorization'] = token
      get :index
    end
  end

  describe '#decoded_header' do
    context 'return permission denied if header is nil' do
      include_examples 'authorization_empty'

      it 'return error' do
        body = JSON.parse(response.body)
        expect(body['error']).to eq(Constants::JSON_WEB_TOKEN[:permission_denied])
      end
    end

    context 'have a permission to call API' do
      include_examples 'authorization_valid'

      it 'return nil if authenticate successfully' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#current_user' do
    context 'return nil if decoded_header is nil' do
      include_examples 'authorization_empty'

      it 'return current_user is nil' do
        expect(subject.instance_variable_get(:@current_user)).to eq(nil)
      end
    end

    context 'return current_user if decoded_header is valid' do
      include_examples 'authorization_valid'

      it 'return current_user' do
        expect(subject.instance_variable_get(:@current_user)).to eq(user)
      end
    end
  end
end

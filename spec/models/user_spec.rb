require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe 'associations' do
    it { should have_many(:file_uploads).dependent(:destroy) }
    it { should have_many(:statistics).dependent(:destroy) }
  end

  describe 'validations' do
    context "Email" do
      it "return error when email is not present" do
        user.email = nil
        expect(user).not_to be_valid
      end

      it "return error when email is not valid" do
        user.email = "test@"
        expect(user).not_to be_valid
      end

      it "return success when email is valid" do
        expect(user).to be_valid
      end
    end
  end
end

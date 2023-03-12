require 'rails_helper'

RSpec.describe FileUpload, type: :model do
  let!(:user) { create(:user) }
  let!(:file_upload) { create(:file_upload, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:statistics).dependent(:destroy) }
  end

  describe 'validations' do
    context "file_name" do
      it "return error when file_name is not present" do
        file_upload.file_name = nil
        expect(file_upload).not_to be_valid
      end

      it "return success when email is valid" do
        expect(file_upload).to be_valid
      end
    end
  end
end

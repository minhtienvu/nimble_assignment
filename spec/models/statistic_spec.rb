require 'rails_helper'

RSpec.describe Statistic, type: :model do
  let!(:user) { create(:user) }
  let!(:file_upload) { create(:file_upload, user: user) }
  let!(:statistic_1) { create(:statistic, keyword: "Ruby", file_upload: file_upload, created_at: DateTime.current) }
  let!(:statistic_2) { create(:statistic, keyword: "Python", file_upload: file_upload, created_at: DateTime.current - 1.days) }

  describe 'associations' do
    context 'belongs_to' do
      it { should belong_to(:file_upload) }
    end
  end

  describe 'validations' do
    context "keyword" do
      it "return error when keyword is not present" do
        statistic_1.keyword = nil
        expect(statistic_1).not_to be_valid
      end

      it "return success when keyword is valid" do
        expect(statistic_1).to be_valid
      end
    end

    context "total_ad_words" do
      it "return error when total_ad_words is not present" do
        statistic_1.total_ad_words = nil
        expect(statistic_1).not_to be_valid
      end

      it "return success when total_ad_words is valid" do
        expect(statistic_1).to be_valid
      end
    end

    context "total_links" do
      it "return error when total_links is not present" do
        statistic_1.total_links = nil
        expect(statistic_1).not_to be_valid
      end

      it "return success when total_links is valid" do
        expect(statistic_1).to be_valid
      end
    end

    context "total_search_results" do
      it "return error when total_search_results is not present" do
        statistic_1.total_search_results = nil
        expect(statistic_1).not_to be_valid
      end

      it "return success when total_search_results is valid" do
        expect(statistic_1).to be_valid
      end
    end

    context "html_code" do
      it "return error when html_code is not present" do
        statistic_1.html_code = nil
        expect(statistic_1).not_to be_valid
      end

      it "return success when html_code is valid" do
        expect(statistic_1).to be_valid
      end
    end
  end

  describe 'scopes' do
    context "order_by_id_desc" do
      it "should return a list of statistics ordered by id desc" do
        expect(Statistic.order_by_id_desc).to eq([statistic_2, statistic_1])
      end
    end

    context "search_like_keywords" do
      it "should return a list of statistics that match the keyword" do
        expect(Statistic.search_like_keywords(statistic_1.keyword)).to eq([statistic_1])
      end
    end
  end
end

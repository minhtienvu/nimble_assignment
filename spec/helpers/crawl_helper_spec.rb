require 'rails_helper'

RSpec.describe CrawlHelper, type: :helper do
  describe '#crawl_google_page' do
    context 'crawl html code from google page' do
      let(:keyword) { 'Ruby' }
      let(:html_code) { Faker::Lorem.paragraphs.map { |pr| "<p>#{pr}</p>" }.join }
      before do
        allow_any_instance_of(CrawlHelper).to receive(:crawl_google_page).with(keyword).and_return(html_code)
      end

      it 'should return html code' do
        crawl_html_page = helper.crawl_google_page(keyword)
        expect(crawl_html_page).to eq(html_code)
      end
    end
  end
end

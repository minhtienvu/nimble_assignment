module GoogleSearcherServices
  include GoogleApiHelper
  include CrawlHelper

  def search_words_from_file(file)
    return raise StandardError, Constants::GOOGLE_API_NOTICE[:file_required] unless file.present?

    data = Roo::Spreadsheet.open(file.tempfile)

    validate_file_data!(data)

    ActiveRecord::Base.transaction do
      statistics = []
      file_upload = current_user.file_uploads.create(file_name: file.original_filename)

      data.each_with_index do |row, index|
        next if row.blank? || index == Constants::HEADER_ROW

        keyword = row.first
        google_search_response = HTTParty.get(google_search_query(keyword))

        return raise StandardError, google_search_response['error']['message'] if google_search_response.code != 200

        google_page_html = crawl_google_page(keyword)
        statistics << generate_response(keyword, google_page_html, google_search_response['searchInformation'])
      end
      file_upload.statistics.insert_all statistics

      file_upload.statistics
    end
  end

  private

  def validate_file_data!(data)
    return unless data.last_row == 0 || data.last_row > 100

    raise StandardError, Constants::GOOGLE_API_NOTICE[:file_data_size_invalid]
  end

  def generate_response(keyword, google_page_html, searchInformation)
    total_search_results = searchInformation ? "About #{searchInformation['formattedTotalResults']} results (#{searchInformation['formattedSearchTime']} seconds)" : "Can't count the results"
    {
      keyword: keyword,
      total_ad_words: google_page_html.search('span.U3A9Ac').count,
      total_links: google_page_html.search('a').length,
      total_search_results: total_search_results,
      html_code: google_page_html.to_s
    }
  end
end

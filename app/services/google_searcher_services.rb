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
        next if index < Constants::START_READ_FROM || row.blank?

        keyword = row.first
        response = HTTParty.get(google_search_query(keyword))

        return raise StandardError, Constants::GOOGLE_API_NOTICE[:fail_to_call_api] if response.code != 200

        google_page_html = crawl_google_page(keyword)
        statistics << generate_response(keyword, google_page_html, response['searchInformation'])
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

  def generate_response(keyword, google_search_page_html, searchInformation)
    total_results = searchInformation['formattedTotalResults']
    total_search_time = searchInformation['formattedSearchTime']
    total_search_results = searchInformation ? "About #{total_results} results (#{total_search_time} seconds)" : "Can't count the results"

    {
      keyword: keyword,
      total_ad_words: '',
      total_links: google_search_page_html.search('a').length,
      total_search_results: total_search_results,
      html_code: google_search_page_html.to_s
    }
  end
end

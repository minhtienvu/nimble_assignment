module GoogleSearcherServices
  include GoogleApiHelper
  include CrawlHelper

  def search_words_from_file(file)
    @file = file
    validate_file!

    ActiveRecord::Base.transaction do
      statistics = create_new_statistics
      statistics
    end
  end

  private

  def validate_file!
    return raise StandardError, Constants::GOOGLE_API_NOTICE[:file_required] if @file.blank?

    return raise StandardError, Constants::GOOGLE_API_NOTICE[:file_type_is_not_csv] if @file.content_type != Constants::CSV_FORMAT

    @data = Roo::Spreadsheet.open(@file.tempfile)
    maximum_data_size = Constants::MAXIMUM_DATA_SIZE + Constants::READ_START_ROW

    if (@data.last_row <= Constants::READ_START_ROW) || (@data.last_row > maximum_data_size)
      raise StandardError, Constants::GOOGLE_API_NOTICE[:file_data_size_invalid]
    end
  end

  def create_new_statistics
    file_upload = current_user.file_uploads.create(file_name: @file.original_filename)
    file_upload.statistics.insert_all get_search_results
    file_upload.statistics
  end

  def get_search_results
    statistics = []

    @data.each_with_index do |row, index|
      next if row.blank? || index < Constants::READ_START_ROW

      keyword = row.first
      google_search_response = HTTParty.get(google_search_query(keyword))

      return raise StandardError, google_search_response['error']['message'] if google_search_response.code != 200

      google_page_html = crawl_google_page(keyword)
      statistics << generate_response(keyword, google_page_html, google_search_response['searchInformation'])
    end

    statistics
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

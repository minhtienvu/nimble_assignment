class GoogleSearchWordsJob
  include Sidekiq::Job
  include GoogleApiHelper
  include CrawlHelper

  def expiration
    @expiration ||= 60 * 60 * 24 * 5 # 5 days
  end

  def perform(args)
    @file = args['file']
    @data = args['data']
    @current_user = User.find_by(id: args['current_user']['id'])
    create_new_statistics
  end

  private

  def create_new_statistics
    @file_upload = @current_user.file_uploads.create(file_name: @file['original_filename'])
    @file_upload.statistics.insert_all! get_search_results
    @file_upload.statistics
  end

  def get_search_results
    statistics = []

    @data.each_with_index do |row, index|
      next if row.blank? || index < Constants::READ_START_ROW

      @keyword = row.first
      @google_search_response = HTTParty.get(google_search_query(@keyword))

      @google_page_html = crawl_google_page(@keyword)

      set_status_and_error_message

      statistics << generate_response
    end

    statistics
  end

  def set_status_and_error_message
    if @google_search_response.code != 200
      @status = Statistic::statuses[:failed]
      @error_message = @google_search_response['error']['message']
    else
      @status = Statistic::statuses[:success]
    end
  end

  def generate_response
    @searchInformation = @google_search_response['searchInformation']
    total_search_results = @searchInformation ? "About #{@searchInformation['formattedTotalResults']} results (#{@searchInformation['formattedSearchTime']} seconds)" : "Can't count the results"
    {
      keyword: @keyword,
      status: @status,
      error_message: @error_message || '',
      total_ad_words: @google_page_html.search('span.U3A9Ac').count,
      total_links: @google_page_html.search('a').length,
      total_search_results: total_search_results,
      html_code: @google_page_html.to_s
    }
  end
end

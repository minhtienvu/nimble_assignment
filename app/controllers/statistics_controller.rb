class StatisticsController < ApplicationController
  include GoogleSearcherServices

  before_action :set_statistics, only: %i[index new]

  def index
    @statistics = @statistics.search_like_keywords(params[:search_keyword]) if params[:search_keyword]
    @pagy, @statistics = pagy(@statistics.order_by_id_desc)
  end

  def new
    @statistic = @statistics.new
  end

  def create
    @statistics = search_words_from_file(params[:statistic][:file])
    @pagy, @statistics = pagy(@statistics.order_by_id_desc)

    return redirect_to statistics_path, notice: Constants::GOOGLE_API_NOTICE[:import_success]
  rescue StandardError => e
    return redirect_to new_statistic_path, alert: e.message
  end

  private

  def set_statistics
    @statistics = current_user.statistics
  end
end

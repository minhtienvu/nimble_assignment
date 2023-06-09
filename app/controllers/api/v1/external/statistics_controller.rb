class Api::V1::External::StatisticsController < Api::V1::External::ApplicationController
  include GoogleSearcherServices

  before_action :authenticate_request!, only: %i[index upload]

  def index
    @statistics = @current_user.statistics.limit(params[:limit]).offset(params[:offset])
                               .order_by_id_desc
    @count = @statistics.count
    @statistics = @statistics.decorate

    render :list
  end

  def upload
    search_words_from_file(params[:file])

    render json: { message: Constants::GOOGLE_API_NOTICE[:file_is_processed] }
  rescue StandardError => e
    render_error(e.message)
  end
end

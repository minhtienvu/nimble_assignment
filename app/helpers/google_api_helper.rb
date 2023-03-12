module GoogleApiHelper

  def google_api_key
    Rails.application.credentials.google_search_api[:api_key]
  end

  def google_engine_id
    Rails.application.credentials.google_search_api[:engine_id]
  end

  def google_search_query(keyword)
    # fields=searchInformation: Load a partial response to reduce the response size
    "#{Constants::CUSTOMER_SEARCH_API}/v1?key=#{google_api_key}&cx=#{google_engine_id}&q=#{keyword}&fields=searchInformation"
  end
end

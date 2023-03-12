require 'nokogiri'
require 'open-uri'

module CrawlHelper
  def crawl_google_page(keyword)
    Nokogiri::HTML5(URI.open("#{Constants::GOOGLE_SEARCH_URL}?q=#{keyword}"))
  end
end

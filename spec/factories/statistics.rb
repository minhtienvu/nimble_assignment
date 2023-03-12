FactoryBot.define do
  factory :statistic do
    file_upload
    keyword { Faker::Name.name }
    total_ad_words { 1 }
    total_links { 1 }
    total_search_results { 'About 1 results (0.01 seconds)' }
    html_code { '<html><body><h1>Test</h1></body></html>' }
  end
end

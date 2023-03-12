FactoryBot.define do
  factory :file_upload, class: 'FileUpload' do
    user
    file_name { 'search_words.csv' }
  end
end

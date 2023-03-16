class Statistic < ActiveRecord::Base
  belongs_to :file_upload

  validates :keyword, presence: true
  validates :total_ad_words, presence: true
  validates :total_links, presence: true
  validates :total_search_results, presence: true
  validates :html_code, presence: true

  enum :status, [:success, :failed]

  scope :order_by_id_desc, -> { order(id: :desc) }

  scope :search_like_keywords, lambda { |keyword|
    where('keyword LIKE ?', "%#{keyword}%")
  }
end

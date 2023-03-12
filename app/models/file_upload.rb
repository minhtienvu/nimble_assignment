class FileUpload < ActiveRecord::Base
  belongs_to :user
  has_many :statistics, dependent: :destroy

  validates :file_name, presence: true
end

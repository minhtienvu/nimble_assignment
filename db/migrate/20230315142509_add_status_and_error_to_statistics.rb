class AddStatusAndErrorToStatistics < ActiveRecord::Migration[7.0]
  def change
    add_column :statistics, :status, :integer, after: :keyword
    add_column :statistics, :error_message, :string, after: :status
  end
end

class AddTableStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :statistics do |t|
      t.integer :file_upload_id
      t.string :keyword
      t.integer :total_ad_words
      t.integer :total_links
      t.string :total_search_results
      t.text :html_code, limit: 16.megabytes - 1

      t.timestamps null: false
    end

    add_index :statistics, :file_upload_id
  end
end

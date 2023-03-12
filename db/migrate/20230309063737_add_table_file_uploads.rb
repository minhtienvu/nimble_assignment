class AddTableFileUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :file_uploads do |t|
      t.integer :user_id
      t.string :file_name

      t.timestamps null: false
    end

    add_index :file_uploads, :user_id
  end
end

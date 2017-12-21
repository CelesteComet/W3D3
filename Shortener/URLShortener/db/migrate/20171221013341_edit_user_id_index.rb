class EditUserIdIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :visits, :user_id
    remove_index :visits, :url_id
  end
end

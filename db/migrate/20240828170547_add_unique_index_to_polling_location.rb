class AddUniqueIndexToPollingLocation < ActiveRecord::Migration[7.1]
  def change
    add_index :polling_locations, [:riding_id, :title, :address, :city, :postal_code], unique: true
  end
end

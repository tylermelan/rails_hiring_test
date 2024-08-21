class CreatePollingLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :polling_locations do |t|
      t.string :title, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :postal_code, null: false
      t.references :riding, null: false, foreign_key: true

      t.timestamps
    end
  end
end

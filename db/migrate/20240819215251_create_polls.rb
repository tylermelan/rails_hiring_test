class CreatePolls < ActiveRecord::Migration[7.1]
  def change
    create_table :polls do |t|
      t.string :number, null: false
      t.references :riding, null: false, foreign_key: true
      t.references :polling_location, null: true, foreign_key: true

      t.timestamps
    end
  end
end

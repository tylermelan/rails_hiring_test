class CreateRidings < ActiveRecord::Migration[7.1]
  def change
    create_table :ridings do |t|
      t.string :name, null: false
      t.string :riding_code, null: false
      t.string :province, null: false

      t.timestamps
    end
  end
end

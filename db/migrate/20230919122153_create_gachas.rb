class CreateGachas < ActiveRecord::Migration[7.0]
  def change
    create_table :gachas do |t|
      t.date :date, null: false
      t.integer :count
      t.string :description
      t.references :user, null: false, foreign_key: true
      t.references :currency_package, foreign_key: true

      t.timestamps
    end
  end
end

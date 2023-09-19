class CreateCurrencyPackages < ActiveRecord::Migration[7.0]
  def change
    create_table :currency_packages do |t|
      t.integer :price, null: false
      t.integer :quantity, null: false
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end

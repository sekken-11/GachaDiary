class CreateCurrencyPackages < ActiveRecord::Migration[7.0]
  def change
    create_table :currency_packages do |t|
      t.string :name, null: false
      t.integer :need_one_gacha_stones, null: false
      t.integer :price, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end

class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.integer :need_one_gacha_stones, null: false

      t.timestamps
    end
  end
end

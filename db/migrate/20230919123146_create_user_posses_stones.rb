class CreateUserPossesStones < ActiveRecord::Migration[7.0]
  def change
    create_table :user_posses_stones do |t|
      t.integer :quantity
      t.references :currency_package, foreign_key: true

      t.timestamps
    end
  end
end

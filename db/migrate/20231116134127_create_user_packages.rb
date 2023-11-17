class CreateUserPackages < ActiveRecord::Migration[7.0]
  def change
    create_table :user_packages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :currency_package, null: false, foreign_key: true

      t.timestamps
    end
    add_index :user_packages, [:user_id, :currency_package_id], unique: true
  end
end

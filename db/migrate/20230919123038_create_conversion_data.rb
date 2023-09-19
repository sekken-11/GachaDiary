class CreateConversionData < ActiveRecord::Migration[7.0]
  def change
    create_table :conversion_data do |t|
      t.references :user, null: false, foreign_key: true
      t.references :currency_package, null: false, foreign_key: true

      t.timestamps
    end
  end
end

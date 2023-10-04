class AddUserIdToPossesStones < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_posses_stones, :user, foreign_key: true, null: false
  end
end

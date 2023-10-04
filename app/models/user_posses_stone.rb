class UserPossesStone < ApplicationRecord
  belongs_to :currency_package
  belongs_to :user
end

class UserPossesStone < ApplicationRecord
  belongs_to :currency_package, optional: true
  belongs_to :user
end

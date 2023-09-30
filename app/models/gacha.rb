class Gacha < ApplicationRecord
  belongs_to :user
  belongs_to :currency_package
end

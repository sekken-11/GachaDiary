class Gacha < ApplicationRecord
  belongs_to :user
  belongs_to :currency_package

  validates :date, presence: true
end

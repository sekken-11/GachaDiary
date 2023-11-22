class Gacha < ApplicationRecord
  belongs_to :user
  belongs_to :currency_package, optional: true

  validates :date, presence: true
end

class CurrencyPackage < ApplicationRecord
  belongs_to :user
  has_many :gachas, dependent: :nullify
  has_many :user_posses_stones, dependent: :nullify

  validates :name, presence: true
  validates :need_one_gacha_stones, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
end

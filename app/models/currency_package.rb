class CurrencyPackage < ApplicationRecord
  has_many :gachas, dependent: :nullify
  has_many :user_posses_stones, dependent: :nullify

  has_many :user_packages
  has_many :users, through: :user_packages

  validates :name, presence: true
  validates :need_one_gacha_stones, presence: true
  validates :quantity, presence: true
  validates :price, presence: true

  enum category: { add: 0, initial: 1 }

end

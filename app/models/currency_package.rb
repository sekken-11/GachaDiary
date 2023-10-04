class CurrencyPackage < ApplicationRecord
  belongs_to :user
  has_many :gachas, dependent: :nullify
  has_many :user_posses_stones, dependent: :nullify
end

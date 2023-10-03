class CurrencyPackage < ApplicationRecord
  belongs_to :user
  has_many :gachas, dependent: :nullify
end

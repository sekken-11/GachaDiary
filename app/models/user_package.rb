class UserPackage < ApplicationRecord
  belongs_to :user
  belongs_to :currency_package

  validates :user_id, uniqueness: { scope: :currency_package_id }
end

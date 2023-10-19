class User < ApplicationRecord
  include JwtToken
  authenticates_with_sorcery!

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true, presence: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  has_many :gachas, dependent: :destroy
  has_many :currency_packages, dependent: :destroy
  has_many :user_posses_stones, dependent: :destroy

end

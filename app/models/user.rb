class User < ApplicationRecord
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :name, :email, :password, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: EMAIL_REGEX

  has_many :items, dependent: :destroy
  has_many :tokens, dependent: :destroy

  def password_right?(password)
    Base64.decode64(self.password) == password
  end
end
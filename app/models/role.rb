class Role < ApplicationRecord
	validates :permission, presence: true

  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
end

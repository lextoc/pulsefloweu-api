class User < ApplicationRecord
  # Include default devise modules.
  # :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :projects, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :timesheets, dependent: :destroy
end

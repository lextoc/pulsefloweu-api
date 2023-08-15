class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :avatar

  has_many :projects, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :time_entries, dependent: :destroy
end

class Project < ApplicationRecord
  belongs_to :user

  has_many :folders, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :user, presence: true
  validates :name, presence: true
end

class Project < ApplicationRecord
  belongs_to :user

  has_many :folders, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :user, presence: true
end

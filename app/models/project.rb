class Project < ApplicationRecord
  belongs_to :user # This is the owner.

  has_many :project_users, dependent: :delete_all
  has_many :users, through: :project_users
  has_many :folders, dependent: :destroy

  validates_length_of :name, minimum: 1, maximum: 100, allow_blank: false
  validates :user, presence: true
end

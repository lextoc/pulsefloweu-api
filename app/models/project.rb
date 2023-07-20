class Project < ApplicationRecord
  belongs_to :user # This is the owner.

  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users # TODO: `dependent: :destroy`
  has_many :folders, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :user, presence: true
end

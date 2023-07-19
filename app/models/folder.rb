class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :project

  has_many :tasks, dependent: :destroy

  validates :user, presence: true
  validates :name, presence: true
  validates :project, presence: true
end

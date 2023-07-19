class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :folder

  validates :user, presence: true
  validates :name, presence: true
  validates :project, presence: true
  validates :folder, presence: true
end

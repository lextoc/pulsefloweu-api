class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :folder

  validates :name, presence: true
  validates :user, presence: true
  validates :project, presence: true
  validates :folder, presence: true
end

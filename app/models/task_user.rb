class TaskUser < ApplicationRecord
  self.table_name = :tasks_users

  enum role: %i[admin member]

  belongs_to :task
  belongs_to :user
  belongs_to :creator, class_name: 'User'

  validates :task, presence: true
  validates :user, presence: true
  validates :creator, presence: true
  validates :role, presence: true
end

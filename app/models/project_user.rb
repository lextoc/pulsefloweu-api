class ProjectUser < ApplicationRecord
  self.table_name = :projects_users

  enum role: %i[admin member]

  belongs_to :project
  belongs_to :user
  belongs_to :creator, class_name: 'User'

  validates :project, presence: true
  validates :user, presence: true
  validates :creator, presence: true
  validates :role, presence: true
end

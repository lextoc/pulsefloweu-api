class FolderUser < ApplicationRecord
  self.table_name = :folders_users

  enum role: %i[admin member]

  belongs_to :folder
  belongs_to :user
  belongs_to :creator, class_name: 'User'

  validates :folder, presence: true
  validates :user, presence: true
  validates :creator, presence: true
  validates :role, presence: true
end

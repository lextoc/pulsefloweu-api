class User < ApplicationRecord
  # Include default devise modules.
  # :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users # TODO: handle deletion

  has_many :folder_users, dependent: :destroy
  has_many :folders_via_membership, through: :folder_users # TODO: handle deletion

  has_many :tasks, dependent: :destroy
  has_many :timesheets, dependent: :destroy

  def folders
    Folder.where(user: self).or(Folder.where(project: projects))
  end
end

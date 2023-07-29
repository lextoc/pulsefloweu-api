class Folder < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user # This is the owner.
  belongs_to :project

  has_many :tasks, dependent: :destroy

  validates_length_of :name, minimum: 1, maximum: 100, allow_blank: false
  validates :user, presence: true
  validates :project, presence: true
end

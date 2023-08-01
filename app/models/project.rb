class Project < ApplicationRecord
  scope :oldest_first, -> { order(created_at: :asc) }

  belongs_to :user # This is the owner.

  has_many :folders, dependent: :destroy

  validates_length_of :name, minimum: 1, maximum: 100, allow_blank: false
  validates :user, presence: true
end

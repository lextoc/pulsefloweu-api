class Task < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :folder

  has_many :time_entries, dependent: :delete_all

  validates_length_of :name, minimum: 1, maximum: 100, allow_blank: false
  validates :user, presence: true
  validates :folder, presence: true
end

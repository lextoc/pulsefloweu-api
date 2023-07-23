class Task < ApplicationRecord
  belongs_to :user
  belongs_to :folder

  validates_length_of :name, minimum: 1, maximum: 100, allow_blank: false
  validates :user, presence: true
  validates :folder, presence: true
end

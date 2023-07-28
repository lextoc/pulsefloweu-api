class TimeEntry < ApplicationRecord
  default_scope { order(start_date: :desc) }

  belongs_to :user
  belongs_to :task
  belongs_to :folder

  validates :start_date, presence: true
  validates :user, presence: true
  validates :folder, presence: true
end

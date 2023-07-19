class Timesheet < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :user, presence: true
  validates :task, presence: true
  validates :start_date, presence: true
  validates :duration, presence: true
end

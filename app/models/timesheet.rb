class Timesheet < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :start_date, presence: true
  validates :duration, presence: true
  validates :user, presence: true
  validates :task, presence: true
end

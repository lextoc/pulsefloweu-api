class Timesheet < ApplicationRecord
  belongs_to :user
  belongs_to :task
  belongs_to :folder

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :user, presence: true
  validates :folder, presence: true
end

class TimeEntry < ApplicationRecord
  scope :recent_first, -> { order(created_at: :desc) }

  belongs_to :user
  belongs_to :task
  belongs_to :folder

  validates :start_date, presence: true

  validates :user, presence: true
  validates :folder, presence: true
  validate :end_date_cannot_be_before_start_date

  def end_date_cannot_be_before_start_date
    return unless end_date.present? && end_date < start_date

    errors.add(:end_date, "can't be before start date")
  end
end

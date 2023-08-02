class Task < ApplicationRecord
  scope :recent_first, -> { order(created_at: :desc) }

  scope :sorted_by_newest_time_entries, lambda {
    left_outer_joins(:time_entries)
      .select('tasks.*', 'MAX(time_entries.start_date) AS newest_time_entry')
      .group('tasks.id')
      .order('newest_time_entry DESC NULLS LAST')
  }

  belongs_to :user
  belongs_to :folder
  has_many :time_entries, dependent: :delete_all

  validates :name, presence: true, length: { minimum: 1, maximum: 100 }
  validates :user, presence: true
  validates :folder, presence: true

  def total_duration_of_time_entries
    time_entries.sum('EXTRACT(epoch FROM COALESCE(end_date, NOW()) - start_date)').to_i
  end
end

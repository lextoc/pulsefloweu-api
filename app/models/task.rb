class Task < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :folder

  has_many :time_entries, dependent: :delete_all

  validates_length_of :name, minimum: 1, maximum: 100, allow_blank: false
  validates :user, presence: true
  validates :folder, presence: true

  def total_duration_of_time_entries
    duration = 0
    time_entries.each do |time_entry|
      duration += ((time_entry.end_date.nil? ? Time.now.getutc.to_f : time_entry.end_date.to_f) -
        time_entry.start_date.to_f).to_i
    end
    duration
  end
end

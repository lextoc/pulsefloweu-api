# frozen_string_literal: true

module TimeEntryAbility
  def time_entry_abilities(user)
    time_entry_read_abilities(user)
    time_entry_create_abilities(user)
    time_entry_update_abilities(user)
    time_entry_destroy_abilities(user)
  end

  private

  def time_entry_read_abilities(user)
    can(:read, TimeEntry) do |time_entry|
      time_entry.user == user
    end
  end

  def time_entry_create_abilities(user)
    can(:create, TimeEntry) do |time_entry|
      time_entry.user == user &&
        # Can only create time_entries in tasks that belong to the user.
        time_entry.task.user == user
    end
  end

  def time_entry_update_abilities(user)
    can(:update, TimeEntry) do |time_entry|
      time_entry.user == user &&
        # Can only update time_entries to tasks that belong to the user.
        time_entry.task.user == user
    end
  end

  def time_entry_destroy_abilities(user)
    can(:destroy, TimeEntry) do |time_entry|
      time_entry.user == user
    end
  end
end

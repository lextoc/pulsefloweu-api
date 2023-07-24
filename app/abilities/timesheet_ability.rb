# frozen_string_literal: true

module TimesheetAbility
  def timesheet_abilities(user)
    timesheet_read_abilities(user)
    timesheet_create_abilities(user)
    timesheet_update_abilities(user)
    timesheet_destroy_abilities(user)
  end

  private

  def timesheet_read_abilities(user)
    can(:read, Timesheet) do |timesheet|
      timesheet.user == user
    end
  end

  def timesheet_create_abilities(user)
    can(:create, Timesheet) do |timesheet|
      timesheet.user == user &&
        # Can only create timesheets in tasks that belong to the user.
        timesheet.task.user == user
    end
  end

  def timesheet_update_abilities(user)
    can(:update, Timesheet) do |timesheet|
      timesheet.user == user &&
        # Can only update timesheets to tasks that belong to the user.
        timesheet.task.user == user
    end
  end

  def timesheet_destroy_abilities(user)
    can(:destroy, Timesheet) do |timesheet|
      timesheet.user == user
    end
  end
end

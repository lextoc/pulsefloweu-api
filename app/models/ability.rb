# frozen_string_literal: true

class Ability
  include CanCan::Ability

  include ProjectAbility
  include FolderAbility
  include TaskAbility
  include TimesheetAbility

  def initialize(user)
    return unless user.present?

    project_abilities(user)
    folder_abilities(user)
    task_abilities(user)
    timesheet_abilities(user)
  end
end

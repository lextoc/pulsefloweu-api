# frozen_string_literal: true

module ProjectUserAbility
  def project_user_abilities(user)
    project_user_read_abilities(user)
    project_user_create_abilities(user)
    project_user_update_abilities(user)
    project_user_destroy_abilities(user)
  end

  private

  def project_user_read_abilities(user)
    can(:read, ProjectUser) do |project_user|
      # Creator or user must be the current user.
      project_user.creator == user || project_user.user == user
    end
  end

  def project_user_create_abilities(user)
    can(:create, ProjectUser) do |project_user|
      # Creator must be the current user.
      project_user.creator == user &&
        # Project must be owned by the current user OR is admin.
        (project_user.project.user == user ||
          project_user.project.project_users.find_by(user:).admin?)
    end
  end

  def project_user_update_abilities(user)
    can(:update, ProjectUser) do |project_user|
      # Creator must be the current user.
      project_user.creator == user &&
        # Project must be owned by the current user OR is admin.
        (project_user.project.user == user ||
          project_user.project.project_users.find_by(user:).admin?)
    end
  end

  def project_user_destroy_abilities(user)
    can(:destroy, ProjectUser) do |project_user|
      # Creator must be the current user.
      project_user.creator == user &&
        # Project must be owned by the current user OR is admin.
        (project_user.project.user == user ||
          project_user.project.project_users.find_by(user:).admin?)
    end
  end
end

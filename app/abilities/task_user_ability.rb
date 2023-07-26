# frozen_string_literal: true

module TaskUserAbility
  def task_user_abilities(user)
    task_user_read_abilities(user)
    task_user_create_abilities(user)
    task_user_update_abilities(user)
    task_user_destroy_abilities(user)
  end

  private

  def task_user_read_abilities(user)
    can(:read, TaskUser) do |task_user|
      # Creator or user must be the current user.
      task_user.creator == user || task_user.user == user
    end
  end

  def task_user_create_abilities(user)
    can(:create, TaskUser) do |task_user|
      # Creator must be the current user.
      task_user.creator == user &&
        # Task must be owned by the current user OR is admin.
        (task_user.task.user == user ||
          task_user.task.task_users.find_by(user:).admin?)
    end
  end

  def task_user_update_abilities(user)
    can(:update, TaskUser) do |task_user|
      # Creator must be the current user.
      task_user.creator == user &&
        # Task must be owned by the current user OR is admin.
        (task_user.task.user == user ||
          task_user.task.task_users.find_by(user:).admin?)
    end
  end

  def task_user_destroy_abilities(user)
    can(:destroy, TaskUser) do |task_user|
      # Creator must be the current user.
      task_user.creator == user &&
        # Task must be owned by the current user OR is admin.
        (task_user.task.user == user ||
          task_user.task.task_users.find_by(user:).admin?)
    end
  end
end

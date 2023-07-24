# frozen_string_literal: true

module TaskAbility
  def task_abilities(user)
    task_read_abilities(user)
    task_create_abilities(user)
    task_update_abilities(user)
    task_destroy_abilities(user)
  end

  private

  def task_read_abilities(user)
    can(:read, Task) do |task|
      task.user == user
    end
  end

  def task_create_abilities(user)
    can(:create, Task) do |task|
      task.user == user &&
        # Can only create tasks in folders that belong to the user.
        task.folder.user == user
    end
  end

  def task_update_abilities(user)
    can(:update, Task) do |task|
      task.user == user &&
        # Can only update tasks to folders that belong to the user.
        task.folder.user == user
    end
  end

  def task_destroy_abilities(user)
    can(:destroy, Task) do |task|
      task.user == user
    end
  end
end

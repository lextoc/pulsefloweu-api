# frozen_string_literal: true

module ProjectAbility
  def project_abilities(user)
    project_read_abilities(user)
    project_create_abilities(user)
    project_update_abilities(user)
    project_destroy_abilities(user)
  end

  private

  def project_read_abilities(user)
    can(:read, Project) do |project|
      project.user == user
    end
  end

  def project_create_abilities(user)
    can(:create, Project) do |project|
      project.user == user
    end
  end

  def project_update_abilities(user)
    can(:update, Project) do |project|
      project.user == user
    end
  end

  def project_destroy_abilities(user)
    can(:destroy, Project) do |project|
      project.user == user
    end
  end
end

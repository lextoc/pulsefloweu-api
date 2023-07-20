# frozen_string_literal: true

module FolderAbility
  def folder_abilities(user)
    folder_read_abilities(user)
    folder_create_abilities(user)
    folder_update_abilities(user)
    folder_destroy_abilities(user)
  end

  private

  def folder_read_abilities(user)
    can :read, Folder do |folder|
      folder.user == user
    end
  end

  def folder_create_abilities(user)
    can :create, Folder do |folder|
      folder.user == user &&
        # Can only create folders in projects that belong to the user.
        folder.project.user == user
    end
  end

  def folder_update_abilities(user)
    can :update, Folder do |folder|
      folder.user == user &&
        # Can only update folders to projects that belong to the user.
        folder.project.user == user
    end
  end

  def folder_destroy_abilities(user)
    can :destroy, Folder do |folder|
      folder.user == user
    end
  end
end

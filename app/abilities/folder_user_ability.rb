# frozen_string_literal: true

module FolderUserAbility
  def folder_user_abilities(user)
    folder_user_read_abilities(user)
    folder_user_create_abilities(user)
    folder_user_update_abilities(user)
    folder_user_destroy_abilities(user)
  end

  private

  def folder_user_read_abilities(user)
    can(:read, FolderUser) do |folder_user|
      # Creator or user must be the current user.
      folder_user.creator == user || folder_user.user == user
    end
  end

  def folder_user_create_abilities(user)
    can(:create, FolderUser) do |folder_user|
      # Creator must be the current user.
      folder_user.creator == user &&
        # Folder must be owned by the current user OR is admin.
        (folder_user.folder.user == user ||
          folder_user.folder.folder_users.find_by(user:).admin?)
    end
  end

  def folder_user_update_abilities(user)
    can(:update, FolderUser) do |folder_user|
      # Creator must be the current user.
      folder_user.creator == user &&
        # Folder must be owned by the current user OR is admin.
        (folder_user.folder.user == user ||
          folder_user.folder.folder_users.find_by(user:).admin?)
    end
  end

  def folder_user_destroy_abilities(user)
    can(:destroy, FolderUser) do |folder_user|
      # Creator must be the current user.
      folder_user.creator == user &&
        # Folder must be owned by the current user OR is admin.
        (folder_user.folder.user == user ||
          folder_user.folder.folder_users.find_by(user:).admin?)
    end
  end
end

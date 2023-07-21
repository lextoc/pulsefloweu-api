class CreateJoinTableFoldersUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :folders, :users do |t|
      # t.index [:folder_id, :user_id]
      # t.index [:user_id, :folder_id]

      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.integer :role

      # Only applicable to members.
      t.boolean :can_view_others_tasks, default: false

      t.timestamps
    end
  end
end

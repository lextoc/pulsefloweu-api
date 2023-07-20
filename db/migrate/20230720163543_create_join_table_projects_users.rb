class CreateJoinTableProjectsUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :projects, :users do |t|
      # t.index [:project_id, :user_id]
      # t.index [:user_id, :project_id]

      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.integer :role
      t.timestamps
    end
  end
end

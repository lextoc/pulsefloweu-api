class CreateJoinTableProjectsUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table(:projects, :users) do |t|
      # t.index [:project_id, :user_id]
      # t.index [:user_id, :project_id]

      t.references(:creator, null: false, foreign_key: { to_table: :users })
      t.integer(:role)
      t.decimal(:price, precision: 12, scale: 2)

      # Only applicable to members.
      t.boolean(:can_view_others_tasks, default: false)

      t.timestamps
    end
  end
end

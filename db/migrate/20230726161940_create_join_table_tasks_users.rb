class CreateJoinTableTasksUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table(:tasks, :users) do |t|
      # t.index [:task_id, :user_id]
      # t.index [:user_id, :task_id]

      t.references(:creator, null: false, foreign_key: { to_table: :users })
      t.integer(:role)
      t.decimal(:price, precision: 12, scale: 2)

      t.timestamps
    end
  end
end

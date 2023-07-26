class CreateTimesheets < ActiveRecord::Migration[7.0]
  def change
    create_table(:timesheets) do |t|
      t.datetime(:start_date)
      t.datetime(:end_date)
      t.references(:user, null: false, foreign_key: true)
      t.references(:task, null: false, foreign_key: true)
      t.references(:folder, null: false, foreign_key: true)

      t.timestamps
    end
  end
end

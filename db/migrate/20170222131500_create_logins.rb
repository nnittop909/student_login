class CreateLogins < ActiveRecord::Migration[5.0]
  def change
    create_table :logins do |t|
      t.integer :student_id

      t.timestamps
    end
  end
end

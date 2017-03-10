class CreateAllotedTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :alloted_times do |t|
      t.decimal :duration

      t.timestamps
    end
  end
end

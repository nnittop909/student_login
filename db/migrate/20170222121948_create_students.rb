class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.integer :gender
      t.string :id_number
      t.string :address
      t.string :slug

      t.timestamps
    end
    add_index :students, :slug, unique: true
  end
end

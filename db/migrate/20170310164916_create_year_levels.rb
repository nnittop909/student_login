class CreateYearLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :year_levels do |t|
      t.string :name
      t.belongs_to :student, foreign_key: true

      t.timestamps
    end
  end
end

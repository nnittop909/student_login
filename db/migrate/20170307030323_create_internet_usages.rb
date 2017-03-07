class CreateInternetUsages < ActiveRecord::Migration[5.0]
  def change
    create_table :internet_usages do |t|
      t.decimal :time_consumption

      t.timestamps
    end
  end
end

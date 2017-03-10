class AddProfilePhotoToStudents < ActiveRecord::Migration[5.0]
  def up
    add_attachment :students, :profile_photo
  end

  def down
    remove_attachment :students, :profile_photo
  end
end

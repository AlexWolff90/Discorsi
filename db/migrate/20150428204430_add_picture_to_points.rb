class AddPictureToPoints < ActiveRecord::Migration
  def change
    add_column :points, :picture, :string
  end
end

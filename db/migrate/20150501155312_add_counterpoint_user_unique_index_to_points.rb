class AddCounterpointUserUniqueIndexToPoints < ActiveRecord::Migration
  def change
		add_index :points, [:user_id, :counterpoint_to_id], unique: true
  end
end

class AddCounterpointToIdToPoints < ActiveRecord::Migration
  def change
    add_column :points, :counterpoint_to_id, :integer
		add_index :points, :counterpoint_to_id
  end
end

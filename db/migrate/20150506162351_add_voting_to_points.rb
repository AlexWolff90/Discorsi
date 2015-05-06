class AddVotingToPoints < ActiveRecord::Migration
  def change
    add_column :points, :upvotes, :integer
    add_column :points, :downvotes, :integer
  end
end

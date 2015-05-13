class RemoveVotingFromPoints < ActiveRecord::Migration
  def change
		change_table :points do |t|
			t.remove :upvotes, :downvotes
		end
  end
end

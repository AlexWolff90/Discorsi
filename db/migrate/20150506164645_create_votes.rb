class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :vote_type
      t.integer :point_id
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :votes, :point_id
    add_index :votes, :user_id
		add_index :votes, [:user_id, :point_id], :unique
		add_index :votes, [:point_id, :vote_type]
  end
end

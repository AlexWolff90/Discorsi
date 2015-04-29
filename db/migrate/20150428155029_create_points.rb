class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.text :content
      t.references :user, index: true

      t.timestamps null: false
    end
		add_index :points, [:user_id, :created_at]
  end
end

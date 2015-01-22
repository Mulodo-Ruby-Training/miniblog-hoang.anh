class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.integer :user_id
    	t.string :title, limit: 100
    	t.string :description, limit: 300
    	t.text :content
    	t.string :image, limit: 100
    	t.boolean :status, default: true
		t.timestamps
    end
  end
end

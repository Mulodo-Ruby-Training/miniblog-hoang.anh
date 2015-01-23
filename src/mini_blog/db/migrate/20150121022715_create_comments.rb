class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.integer :user_id, :post_id
    	t.string :content, limit: 250
		t.timestamps
    end
  end
end

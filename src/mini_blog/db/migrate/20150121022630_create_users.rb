class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :username, limit: 64
    	t.string :salt_password, limit: 100
    	t.string :password, limit: 100
    	t.string :token, limit: 100
    	t.string :firstname, limit: 30
    	t.string :lastname, limit: 30
    	t.string :avatar, limit: 100
    	t.string :address, limit: 200
    	t.string :city, limit: 30
    	t.string :email, limit: 50
    	t.string :mobile, limit: 20
    	t.boolean :gender, default: true
    	t.date :birthday
		t.timestamps
    end
  end
end

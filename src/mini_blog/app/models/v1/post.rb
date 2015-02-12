module V1
  class Post < ActiveRecord::Base
    #Relationship to users and comments
    has_many :comment, dependent: :destroy
    belongs_to :user

    validates_presence_of :title
    validates_presence_of :content
    validates_presence_of :user_id, on: :create
    validates_presence_of :status

    # function to insert post into database
    def self.insert_post(data)
      post = self.new(data)
      if(post.save rescue nil)
        V1::User.return_result({code: 200, description:"Post is created successfully",
            messages:"Successful",data: nil})
      else
        V1::User.return_result({code: 1001, description:"Post is created unsuccessfully",
            messages:post.errors,data: nil})
      end
    end

    # function to update post from database
    def self.update_post(post_id,data)
      post = self.find(post_id)
      if(post.update(data) rescue nil)
        V1::User.return_result({code: 200, description:"Post is updated successfully",
            messages:"Successful",data: nil})
      else
        V1::User.return_result({code: 1001, description:"Post is updated unsuccessfully",
            messages:post.errors,data: nil})
      end
    end

    # function to delete post from database
    def self.delete_post(post_id)
      post = self.find(post_id)
      if(post.destroy() rescue nil)
        V1::User.return_result({code: 200, description:"Post is deleted successfully",
              messages:"Successful",data: nil})
      else
        V1::User.return_result({code: 2504, description:"Post is deleted unsuccessfully",
              messages:"Unsuccessful",data: nil})
      end
    end

    def self.active_or_deactive_post(post_id,status)
      if post_id == "" || status == ""
        V1::User.return_result({code: 1001, description:"Post is updated unsuccessfully",
              messages:"Post id or status not input",data: nil})
      end
      post = self.find(post_id)
      if(post.update_attribute('status', status) rescue nil)
        V1::User.return_result({code: 200, description:"Post is updated successfully",
              messages:"Successful",data: nil})
      else
        V1::User.return_result({code: 2503, description:"Post is updated unsuccessfully",
              messages:"Unsuccessful",data: nil})
      end
    end

  end
end

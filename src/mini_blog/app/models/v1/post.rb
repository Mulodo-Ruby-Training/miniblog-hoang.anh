module V1
  class Post < ActiveRecord::Base
    #Relationship to users and comments
    has_many :comment, dependent: :destroy
    belongs_to :user

    validates_presence_of :title
    validates_presence_of :content
    validates_presence_of :user_id, on: :create
    # validates_presence_of :status

    # function to insert post into database
    def self.insert_post(data)
      post = self.new(data)
      if(post.save rescue nil)
        V1::User.return_result({code: STATUS_OK, description:"Post is created successfully",
            messages:"Successful",data: nil})
      else
        V1::User.return_result({code: ERROR_VALIDATE, description:MSG_VALIDATE,
            messages:post.errors,data: nil})
      end
    end

    # function to update post from database
    def self.update_post(post_id,data)
      post = self.find(post_id)
      if(post.update(data) rescue nil)
        V1::User.return_result({code: STATUS_OK, description:"Post is updated successfully",
            messages:"Successful",data: nil})
      else
        V1::User.return_result({code: ERROR_VALIDATE, description:MSG_VALIDATE,
            messages:post.errors,data: nil})
      end
    end

    # function to delete post from database
    def self.delete_post(post_id)
      post = self.find(post_id)
      if(post.destroy() rescue nil)
        V1::User.return_result({code: STATUS_OK, description:"Post is deleted successfully",
              messages:"Successful",data: nil})
      else
        V1::User.return_result({code: ERROR_DELETE_POST_FAILED, description:MSG_DELETE_POST_FAILED,
              messages:"Unsuccessful",data: nil})
      end
    end

    # function to change status of post
    def self.active_or_deactive_post(post_id,status)
      if post_id == "" || status == ""
        V1::User.return_result({code: ERROR_VALIDATE, description:MSG_VALIDATE,
              messages:"Post id or status not input",data: nil})
      end
      post = self.find(post_id)
      if(post.update_attribute('status', status) rescue nil)
        V1::User.return_result({code: STATUS_OK, description:"Post is updated successfully",
              messages:"Successful",data: nil})
      else
        V1::User.return_result({code: ERROR_UPDATE_POST_FAILED, description:MSG_UPDATE_POST_FAILED,
              messages:"Unsuccessful",data: nil})
      end
    end

    # function to get all posts    
    def self.get_all_post
      users = (self.all rescue nil)
      if users
        V1::User.return_result({code: STATUS_OK, description:"Get all posts successfully",
              messages:"Successful",data: users})
      else
        V1::User.return_result({code: ERROR_CREATE_COMMENT_FAILED, description:MSG_GET_ALL_POST_FAILED,
              messages:"Unsuccessful",data: nil})
      end
    end

    # function to get all comments of a post
    def self.get_all_comments_post(post_id)
      #code
    end

  end
end

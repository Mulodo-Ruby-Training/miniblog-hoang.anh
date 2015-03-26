module V1
  class Comment < ActiveRecord::Base
    #Relationship to posts and users
    belongs_to :user
    belongs_to :post

    #validate
    validate :user_id_exists
    validate :post_id_exists
    validates :user_id, :post_id, :content, presence:true
    validates :content, length: {minimum: 5}
    validates :content, length: {maximum: 250}

    # function to create a new comment
    def self.create_comment(data)
      comment = self.new(data)
      if(comment.save(data) rescue nil)
        V1::User.return_result({code: STATUS_OK, 
          description:MSG_CREATE_COMMENT_SUCCESS,
          messages:"Successful",data: nil})
      else
        V1::User.return_result({code: ERROR_CREATE_COMMENT_FAILED,
          description:MSG_CREATE_COMMENT_FAILED,
          messages:comment.errors,data: nil})
      end
    end

    # funtion to edit a existed comment
    def self.edit_comment(comment_id,data)
      begin
        comment = Comment.find(comment_id)
      rescue ActiveRecord::RecordNotFound
        return V1::User.return_result({code: ERROR_GET_ID_COMMENT_NOT_EXIST,
          description:MSG_GET_ID_COMMENT_NOT_EXIST,
          messages:"Unsuccessful",data: nil})
      end

      # Check comment belongs to user and post
      if data[:user_id].to_i != comment[:user_id].to_i ||
        data[:post_id].to_i != comment[:post_id].to_i
        return V1::User.return_result({code: ERROR_ID_USER_OR_ID_POST_IS_WRONG,
          description:MSG_ID_USER_OR_ID_POST_IS_WRONG,
          messages:"Unsuccessful",data: nil})
      end

      # Check updating comment
      if comment.update(data)
        return V1::User.return_result({code: STATUS_OK,
          description:MSG_UPDATE_COMMENT_SUCCESS,
          messages:"Successful",data: nil}) 
      else
        return V1::User.return_result({code: ERROR_UPDATE_COMMENT_FAILED,
          description:MSG_UPDATE_COMMENT_FAILED,
          messages:"Successful",data: nil}) 
      end
    end

    def self.delete_comment(comment_id,user_id)
      begin
        comment = Comment.find(comment_id)
      rescue ActiveRecord::RecordNotFound
        return V1::User.return_result({code: ERROR_GET_ID_COMMENT_NOT_EXIST,
          description:MSG_GET_ID_COMMENT_NOT_EXIST,
          messages:"Unsuccessful",data: nil})
      end

      if comment[:user_id].to_i != user_id.to_i
        return V1::User.return_result({code: ERROR_ID_USER_OR_ID_POST_IS_WRONG,
          description:MSG_ID_USER_OR_ID_POST_IS_WRONG,
          messages:"Unsuccessful",data: nil})
      end

      if(comment.destroy rescue nil)
        return V1::User.return_result({code:STATUS_OK,
          description:MSG_DELETE_COMMENT_SUCCESS,
          messages:"Successful",data: nil})
      else
        return V1::User.return_result({code:ERROR_DELETE_COMMENT_FAILED,
          description:MSG_DELETE_COMMENT_FAILED,
          messages:"Unsuccessful",data: nil})
      end

    end

    private
    # function check user_id exists from database
    def user_id_exists
      begin
        User.find(self.user_id)
      rescue ActiveRecord::RecordNotFound
        errors.add(:user_id,'wrong user id')
        false
      end
    end

    #function check post_id exists from database
    def post_id_exists
      begin
        Post.find(self.post_id)
      rescue ActiveRecord::RecordNotFound
        errors.add(:post_id,'wrong post id')
        false
      end
    end

  end
end

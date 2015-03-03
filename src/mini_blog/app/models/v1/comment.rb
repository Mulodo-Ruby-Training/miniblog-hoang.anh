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
      #code
    end

    def self.delete_comment(comment_id)
      #code
    end

    private
    def user_id_exists
      begin
        User.find(self.user_id)
      rescue ActiveRecord::RecordNotFound
        errors.add(:user_id,'wrong user id')
        false
      end
    end

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

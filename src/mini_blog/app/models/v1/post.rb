module V1
  class Post < ActiveRecord::Base
    #Relationship to users and comments
    include Utility
    has_many :comment, dependent: :destroy
    belongs_to :user

    search_syntax do
      search_by :text do |scope, phrases|
        columns = [:title, :description, :content]
        scope.where_like(columns => phrases)
      end
    end

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
    def self.update_post(post_id,user_id,data)
      post = self.find(post_id)
      if post[:user_id].to_i != user_id.to_i
        return V1::User.return_result({code:ERROR_ID_USER_OR_ID_POST_IS_WRONG, description:MSG_ID_USER_OR_ID_POST_IS_WRONG,
          messages:"Unsuccessful",data: nil})
      end

      if(post.update(data) rescue nil)
        V1::User.return_result({code: STATUS_OK, description:"Post is updated successfully",
          messages:"Successful",data: nil})
      else
        V1::User.return_result({code: ERROR_VALIDATE, description:MSG_VALIDATE,
          messages:post.errors,data: nil})
      end
    end

    # function to delete post from database
    def self.delete_post(post_id,user_id)
      post = (self.find(post_id) rescue nil)

      if (post[:user_id].to_i != user_id.to_i rescue nil)
        return V1::User.return_result({code:ERROR_ID_USER_OR_ID_POST_IS_WRONG, description:MSG_ID_USER_OR_ID_POST_IS_WRONG,
          messages:"Unsuccessful",data: nil})
      end

      if(post && post.destroy() rescue nil)
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
        return V1::User.return_result({code: ERROR_VALIDATE, description:MSG_VALIDATE,
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
    def self.get_all_post(limit=10,order=nil,page=1,per_page=10)

      page = 1 if page == 0
      per_page = 10 if per_page.to_i == 0

      case order
      when 'newest'
        order = 'id desc'
      when 'most_comment'
        order = 'most_comment'
      when 'name'
        order = 'title asc'
      else
        order = 'id desc'
      end


      if !(order.eql?('most_comment'))
        posts = (self.joins(:user)
          .select("posts.id, posts.user_id,title,description,image,status,posts.created_at,firstname, lastname")
          .where("status= 1")
          .limit(limit)
          .order(order)
          .page(page)
          .per(per_page) rescue nil)
      else
        posts = (self.joins(:user, :comment)
          .select("count(comments.id) as comment_count,posts.id, posts.user_id,title,description,image,status,posts.created_at,firstname, lastname")
          .where("status= 1")
          .limit(limit)
          .group('posts.id')
          .order('comment_count desc')
          .page(page)
          .per(per_page) rescue nil)
      end
      
      count_total_items = posts.total_count
      if count_total_items % per_page.to_i == 0
        count_total_pages = count_total_items / per_page.to_i
      else
        count_total_pages = count_total_items / per_page.to_i + 1
      end

      if posts
        V1::User.return_result({code: STATUS_OK, description:"Get all posts successfully",
          messages:"Successful",data: posts,pagination:{items:count_total_items,pages:count_total_pages}})
      else
        V1::User.return_result({code: ERROR_GET_ALL_POST_FAILED, description:MSG_GET_ALL_POST_FAILED,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to get a certain post
    def self.get_a_post(post_id)
      posts = self.where("posts.id=#{post_id}")
      .where("posts.status=1")
      .joins(:user)
      .limit(1)
      .select("posts.id, posts.user_id,title,content,image,status,posts.created_at,
        firstname, lastname,avatar,users.created_at as joined_at")
      if posts
        V1::User.return_result({code:STATUS_OK,description:"Get a post successfully",
          messages:"Successful",data:posts})
      else
        V1::User.return_result({code:ERROR_ID_USER_OR_ID_POST_IS_WRONG,description:MSG_ID_USER_OR_ID_POST_IS_WRONG,
          messages:"Unuccessful",data:nil})
      end
    end
    #function to search posts
    def self.search_posts(user_id,keyword,page=1,per_page=10)
      page = 1 if page == 0
      per_page = 10 if per_page == 0

      posts = self.search(keyword).where("user_id = #{user_id}").order('id desc').page(page).per(per_page)
      count_total_items = posts.total_count
      if count_total_items % per_page == 0
        count_total_pages = count_total_items / per_page
      else
        count_total_pages = count_total_items / per_page + 1
      end
      V1::User.return_result({code:STATUS_OK,description:"Get posts successfully",
        messages:"Successful",data:posts,pagination:{items:count_total_items,pages:count_total_pages}})
    end

    # function to get all comments of a post
    def self.get_all_comments_post(post_id,page=1)
      page = 1 if page == 0

      comments = (V1::Comment.where("post_id = #{post_id}")
        .joins(:user)
        .select('comments.id,comments.user_id,content,comments.created_at,users.lastname,users.firstname,users.avatar')
        .order("comments.created_at desc")
        .page(page).per(5) rescue nil)

      count_total_items = comments.total_count
      if count_total_items % 5 == 0
        count_total_pages = count_total_items / 5
      else
        count_total_pages = count_total_items / 5 + 1
      end

      if comments
        V1::User.return_result({code:STATUS_OK,description:"Get all comments successfully",
          messages:"Successful",data:comments,pagination:{items:count_total_items,pages:count_total_pages}})
      else
        V1::User.return_result({code:ERROR_GET_ALL_COMMENT_POST_ERROR,description:MSG_GET_ALL_COMMENT_POST_ERROR,
          messages:"Unsuccessful",data:nil})
      end
    end

  end
end

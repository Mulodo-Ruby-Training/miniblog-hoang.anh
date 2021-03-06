module V1
  class PostsController < ApplicationController
    respond_to :json
    skip_before_filter :verify_authenticity_token

    #function to user can create a post
    def create
      session_id = params[:session_id]
      session_token = params[:session_token]
      if V1::User.check_login(session_id,session_token)
        if params[:image]
          io = V1::FileStringUpload.new(Base64.decode64(params[:image]))
          io.original_filename = params[:name_original_image].to_s
          params[:image] = io
        end
        user_id = session_id
        data = {
          title: params[:title],
          content: params[:content],
          description: params[:description],
          image: params[:image],
          status: params[:status],
          user_id: user_id
        }
        render json: V1::Post.insert_post(data)
      else
        render json: V1::User.return_result({code:ERROR_NOT_LOGIN,description:MSG_NOT_LOGIN,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to user can update a existed post
    def update
      session_id = params[:session_id]
      session_token = params[:session_token]
      if V1::User.check_login(session_id,session_token)
        if params[:image]
          io = V1::FileStringUpload.new(Base64.decode64(params[:image]))
          io.original_filename = params[:name_original_image].to_s
          params[:image] = io
        end
        post_id = params[:id]
        data = {
          title: params[:title],
          content: params[:content],
          description: params[:description],
          image: params[:image],
          status: params[:status],
        }
        render json: V1::Post.update_post(post_id,session_id,data)
      else
        render json: V1::User.return_result({code:ERROR_NOT_LOGIN,description:MSG_NOT_LOGIN,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to user can delete a existed post
    def destroy
      session_id = params[:session_id]
      session_token = params[:session_token]
      if V1::User.check_login(session_id,session_token)
        post_id = params[:id]
        render json: V1::Post.delete_post(post_id,session_id)
      else
        render json: V1::User.return_result({code:ERROR_NOT_LOGIN,description:MSG_NOT_LOGIN,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to user can active or deactive their post
    def change_status
      if V1::User.check_login(session[:id],session[:token])
        post_id = params[:id]
        status = params[:status]
        render json: V1::Post.active_or_deactive_post(post_id,status)
      else
        render json: V1::User.return_result({code:ERROR_NOT_LOGIN,description:MSG_NOT_LOGIN,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to show all posts
    def index
      limit = params[:limit].to_i
      page = params[:page].to_i
      per_page = params[:per_page].to_i
      order = params[:order].to_s
      render json: V1::Post.get_all_post(limit,order,page,per_page)
    end

    #function to get all comments of a certain post
    def show_all_comments_post
      post_id = params[:id]
      page = params[:page].to_i
      render json: V1::Post.get_all_comments_post(post_id,page)
    end

    #function to get a certain post
    def show
      post_id = params[:id]
      render json: V1::Post.get_a_post(post_id)
    end

    def search
      page = params[:page].to_i
      per_page = params[:per_page].to_i
      keyword = params[:keyword]
      user_id = params[:id].to_i
      render json: V1::Post.search_posts(user_id,keyword,page,per_page)
    end

  end
end
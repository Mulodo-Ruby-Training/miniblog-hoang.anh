module V1
  class PostsController < ApplicationController
    respond_to :json
    skip_before_filter :verify_authenticity_token

    #function to user can create a post
    def create 
      if V1::User.check_login(session[:id],session[:token])
        user_id = session[:id]
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
        render json: V1::User.return_result({code:ERROR_TOKEN_EXPIRED,description:MSG_TOKEN_EXPIRED,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to user can update a existed post
    def update
      if V1::User.check_login(session[:id],session[:token])
        post_id = params[:id]
        data = {
          title: params[:title],
          content: params[:content],
          description: params[:description],
          image: params[:image],
          status: params[:status],
        }
        render json: V1::Post.update_post(post_id,data)
      else
        render json: V1::User.return_result({code:ERROR_TOKEN_EXPIRED,description:MSG_TOKEN_EXPIRED,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to user can delete a existed post
    def destroy
      if V1::User.check_login(session[:id],session[:token])
        post_id = params[:id]
        render json: V1::Post.delete_post(post_id)
      else
        render json: V1::User.return_result({code:ERROR_TOKEN_EXPIRED,description:MSG_TOKEN_EXPIRED,
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
        render json: V1::User.return_result({code:ERROR_TOKEN_EXPIRED,description:MSG_TOKEN_EXPIRED,
          messages:"Unsuccessful",data: nil})
      end
    end

  end
end
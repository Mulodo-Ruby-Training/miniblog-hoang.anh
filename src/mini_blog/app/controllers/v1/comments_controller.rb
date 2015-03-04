module V1
  class CommentsController < ApplicationController
    respond_to :json
    skip_before_filter :verify_authenticity_token

    #function to create a comments
    def create
      if V1::User.check_login(session[:id],session[:token])
        user_id = session[:id]
        data = {
          user_id: user_id,
          post_id: params[:post_id],
          content: params[:content]
        }
        render json: V1::Comment.create_comment(data)
      else
        render json: V1::User.return_result({code:ERROR_TOKEN_EXPIRED,
          description:MSG_TOKEN_EXPIRED,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to edit a comments
    def edit
      if V1::User.check_login(session[:id],session[:token])
        user_id = session[:id]
        comment_id = params[:id]
        data = {
          user_id: user_id,
          post_id: params[:post_id],
          content: params[:content]
        }
        render json: V1::Comment.edit_comment(comment_id,data)
      else
        render json: V1::User.return_result({code:ERROR_TOKEN_EXPIRED,
          description:MSG_TOKEN_EXPIRED,
          messages:"Unsuccessful",data: nil})
      end
    end

    # function to delete a comments
    def delete
      #code
    end
  end
end
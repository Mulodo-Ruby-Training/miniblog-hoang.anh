module V1
  class CommentsController < ApplicationController
    respond_to :json
    skip_before_filter :verify_authenticity_token

    #function to create a comments
    def create
      session_id = params[:session_id]
      session_token = params[:session_token]
      if V1::User.check_login(session_id,session_token)
        user_id = session_id
        data = {
          user_id: user_id,
          post_id: params[:post_id],
          content: params[:content]
        }
        render json: V1::Comment.create_comment(data)
      else
        render json: V1::User.return_result({code:ERROR_NOT_LOGIN,
          description:MSG_NOT_LOGIN,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to edit a comments
    def edit
      session_id = params[:session_id]
      session_token = params[:session_token]
      if V1::User.check_login(session_id,session_token)
        comment_id = params[:id]
        data = {
          user_id: session_id,
          post_id: params[:post_id],
          content: params[:content]
        }
        render json: V1::Comment.edit_comment(comment_id,data)
      else
        render json: V1::User.return_result({code:ERROR_NOT_LOGIN,
          description:MSG_NOT_LOGIN,
          messages:"Unsuccessful",data: nil})
      end
    end

    # function to delete a comments
    def delete
      session_id = params[:session_id]
      session_token = params[:session_token]
      if V1::User.check_login(session_id,session_token)
        comment_id = params[:id]
        render json: V1::Comment.delete_comment(comment_id,session_id) 
      else
        render json: V1::User.return_result({code:ERROR_NOT_LOGIN,
          description:MSG_NOT_LOGIN,
          messages:"Unsuccessful",data: nil})
      end
    end
    
  end
end

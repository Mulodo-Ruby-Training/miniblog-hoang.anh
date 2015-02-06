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
        render json: V1::User.return_result({code:1002,description:"Token invalid",
          messages:"Unsuccessful",data: nil})
      end    
    end

  end
end
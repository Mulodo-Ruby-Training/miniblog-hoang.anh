module V1
  class UsersController < ApplicationController
    respond_to :json
    skip_before_filter :verify_authenticity_token

    #function to create a user account
    def create
      data_input = {
        username: params[:username],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        firstname: params[:firstname],
        lastname: params[:lastname],
        avatar: params[:avatar],
        address: params[:address],
        city: params[:city],
        email: params[:email],
        mobile: params[:mobile],
        gender: params[:gender],
        birthday: params[:birthday]
      }
      #Call function insert_user from model V1:User and render result to json
      render json: V1::User.insert_user(data_input)
    end

    #function to login for user
    def login
      username = params[:username]
      password = params[:password]
      session_id = params[:session_id]
      session_token = params[:session_token]
      #Call function check_login from model V1::User
      if V1::User.check_login(session_id,session_token) == false
        #Call function login from model V1::User
        result = V1::User.login(username,password)
        # session[:id] = (result[:data][:id]) rescue nil
        # session[:token] = (result[:data][:token]) rescue nil
        render json: result
      else
        render json: V1::User.return_result({code:ERROR_USERNAME_USED,description:MSG_USERNAME_USED,
          messages:"Already login",data: nil})
      end
    end

    # function to update user's info
    def update
      session_id = params[:session_id]
      session_token = params[:session_token]
      data_input = {
        firstname: params[:firstname],
        lastname: params[:lastname],
        avatar: params[:avatar],
        address: params[:address],
        city: params[:city],
        email: params[:email],
        mobile: params[:mobile],
        gender: params[:gender],
        birthday: params[:birthday]
      }

      #Call function check_login from model V1::User
      if V1::User.check_login(session_id,session_token)
        #Call function update_user from model V1:User and render result to json
        render json: V1::User.update_user(session_id,data_input)
      else
        render json: V1::User.return_result({code:ERROR_NOT_LOGIN,description:MSG_NOT_LOGIN,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to logout for user
    def logout
      session_id = params[:session_id]
      #Update token to null
      if V1::User.update_token(session_id)
        #Destroy all session
        session.clear

        render json:{
          meta:{
            code: STATUS_OK,
            description: "Logout successfully",
            messages: "Successful"
            },
          data: nil
        }
      else
        render json:{
          meta:{
            code: ERROR_UPDATE_TOKEN,
            description: MSG_UPDATE_TOKEN,
            messages: "Unsuccessful"
            },
          data: nil
        }
      end
    end

    #function to user change their password
    def change_password
      session_id = params[:session_id]
      session_token = params[:session_token]
      if V1::User.check_login(session_id,session_token)
        data = {
          current_password: params[:current_password],
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        }
        result = V1::User.change_user_password(session_id, data)
        render json: result
      else
        render json: V1::User.return_result({code:ERROR_NOT_LOGIN,description:MSG_NOT_LOGIN,
          messages:"Unsuccessful",data: nil})
      end
    end

    #function to show infor of a existed user
    def show
      id = params[:id]
      render json: V1::User.get_user_info(id)
    end

    #function to search all user by name
    def search
      keyword = params[:keyword]
      page = params[:page]
      per_page = params[:per_page]
      render json: V1::User.search_user_by_name(keyword,page,per_page)
    end
    
    def show_posts_user
      page = params[:page]
      per_page = params[:per_page]
      user_id = params[:id]
      order = params[:order]
      render json: V1::User.get_all_post_user(user_id,order,page,per_page)
    end

    #function to get all comments of a certain user
    def show_all_comments_user
      user_id = params[:id]
      render json: V1::User.get_all_comments_user(user_id)
    end

  end
end

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

      #Call function check_login from model V1::User
      if V1::User.check_login(session[:id],session[:token]) == false
        #Call function login from model V1::User
        result = V1::User.login(username,password)
        session[:id] = (result[:data][:id]) rescue nil
        session[:token] = (result[:data][:token]) rescue nil
        render json: result
      else
        render json:{
          meta:{
            code: 2001,
            description: "This username is already in used",
            messages: "Already login"
          },
          data: nil
        }
      end
    end

    # function to update user's info
    def update
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
      if V1::User.check_login(session[:id],session[:token])
        #Call function update_user from model V1:User and render result to json
        render json: V1::User.update_user(params[:id],data_input)
      else
        render json:{
          meta:{
            code: 1002,
            description: "Token invalid",
            messages: "Unsuccessful"
            },
          data: nil
        }
      end
    end

    #function to logout for user
    def logout
      #Update token to null
      if V1::User.update_token(params[:id])
        #Destroy all session
        session.clear

        render json:{
          meta:{
            code: 200,
            description: "Logout successfully",
            messages: "Successful"
            },
          data: nil
        }
      else
        render json:{
          meta:{
            code: 1005,
            description: "Update token fails",
            messages: "Unsuccessful"
            },
          data: nil
        }
      end
    end

  end
end

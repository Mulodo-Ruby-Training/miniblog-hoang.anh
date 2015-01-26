module V1
  class UsersController < ApplicationController
    respond_to :json
    skip_before_filter :verify_authenticity_token
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

    def login
      username = params[:username]
      password = params[:password]
      if V1::User.check_login(session[:id],session[:token]) == false
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
  end
end

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
			render json: V1::User.insert_user(data_input)
		end
	end
end

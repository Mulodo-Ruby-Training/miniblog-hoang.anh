class UsersController < ApplicationController
  def create
    if params[:user]["birthday(1i)"] !="" && params[:user]["birthday(2i)"] != "" && params[:user]["birthday(3i)"] != ""
      params[:user][:birthday] = Date.civil(params[:user]["birthday(1i)"].to_i,params[:user]["birthday(2i)"].to_i,params[:user]["birthday(3i)"].to_i)
    end
    # if params[:user][:avatar]
    #   data_image = StringIO.new(Base64.decode64(params[:user][:avatar]))
    #   data_image.class.class_eval { attr_accessor :original_filename, :content_type }
    #   data_image.original_filename = params[:user][:avatar].original_filename
    #   data_image.content_type = params[:user][:avatar].content_type 
    #   params[:user][:avatar] = data_image
    # end
    data_input = params[:user]
    resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users'),data_input)
    data_output = JSON.parse(resp.body)
    if data_output["meta"]["code"].to_i == 1001
      flash[:errors] = data_output["meta"]["messages"]
    else
      flash[:notice] = data_output["meta"]["description"]
    end

    redirect_to({action:'signup'})
  end

  def login
    params[:user][:session_id] = session[:id]
    params[:user][:session_token] = session[:token]
    data_input = params[:user]
    resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users/login'),data_input)
    data_output = JSON.parse(resp.body)
    if data_output["meta"]["code"].to_i == 200
      session[:id] = data_output["data"]["id"]
      session[:token] = data_output["data"]["token"]
      flash[:notice] = data_output["meta"]["description"]
    else
      flash[:errors] = data_output["meta"]["description"]
    end
    redirect_to({action:'signin'})
  end

  def logout
    resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users/logout'),
      {session_id:session[:id]})
    data_output = JSON.parse(resp.body)
    if data_output["meta"]["code"].to_i == 200
      flash[:notice] = data_output["meta"]["description"]
    else
      flash[:errors] = data_output["meta"]["description"]
    end
    redirect_to({action:'signin'})
  end
end

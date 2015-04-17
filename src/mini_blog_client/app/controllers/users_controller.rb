require 'base64'
class UsersController < ApplicationController
  include Utility
  def create
    if params[:user][:avatar]

      url_image = User::upload(params[:user][:avatar])
      if url_image != false
        string_encode = Base64.encode64(File.open(Rails.root.to_s + "/public" + url_image.to_s,"rb").read)
        original_image = params[:user][:avatar].original_filename
        params[:user][:avatar] = string_encode
        params[:user][:name_original_avatar] = original_image
        # File.delete(Rails.root.to_s + "/public" + url_image.to_s)
      end

    end

    if params[:user]["birthday(1i)"] !="" && params[:user]["birthday(2i)"] != "" && params[:user]["birthday(3i)"] != ""
      params[:user][:birthday] = Date.civil(params[:user]["birthday(1i)"].to_i,params[:user]["birthday(2i)"].to_i,params[:user]["birthday(3i)"].to_i)
    end
  
    data_input = params[:user]
    data_output = ::Utility.send_request_to_host_api("post",DOMAIN_HOST+VERSION_API+"/"+USERS_TABLE,data_input)
    
    if data_output["meta"]["code"].to_i == 1001
      flash[:errors] = data_output["meta"]["messages"]
    else
      if data_output["meta"]["code"].to_i == 200
        flash[:notice] = data_output["meta"]["description"]
      else
        flash[:error] = data_output["meta"]["description"]
      end
    end
    redirect_to({action:'signup'})
  end

  # function to render UI update info
  def edit
    if session[:id] && session[:token]
      
      data_output = ::Utility.send_request_to_host_api("get",DOMAIN_HOST+VERSION_API+"/"+USERS_TABLE+"/"+session[:id].to_s)
      
      if data_output["meta"]["code"].to_i == 200
        @data_view = data_output["data"]
      else
        @error = data_output["meta"]["description"]
      end
    else
      redirect_to({action:'signin'})
    end
    
  end

  # function to call API update info
  def update
    if session[:id] && session[:token]

      if params[:user][:avatar]
      url_image = User::upload(params[:user][:avatar])
        if url_image != false
          string_encode = Base64.encode64(File.open(Rails.root.to_s + "/public" + url_image.to_s,"rb").read)
          original_image = params[:user][:avatar].original_filename
          params[:user][:avatar] = string_encode
          params[:user][:name_original_avatar] = original_image
          # File.delete(Rails.root.to_s + "/public" + url_image.to_s)
        end
      end

      if params[:user]["birthday(1i)"] !="" && params[:user]["birthday(2i)"] != "" && params[:user]["birthday(3i)"] != ""
        params[:user][:birthday] = Date.civil(params[:user]["birthday(1i)"].to_i,params[:user]["birthday(2i)"].to_i,params[:user]["birthday(3i)"].to_i)
      end

      params[:user][:session_id] = session[:id]
      params[:user][:session_token] = session[:token]
      data_input = params[:user]
      data_output = ::Utility.send_request_to_host_api("put",DOMAIN_HOST+VERSION_API+"/"+USERS_TABLE+"/"+session[:id].to_s,data_input)

      if data_output["meta"]["code"].to_i == 1001
        flash[:errors] = data_output["meta"]["messages"]
      else
        if data_output["meta"]["code"].to_i == 200
          flash[:notice] = data_output["meta"]["description"]
        else
          flash[:error] = data_output["meta"]["description"]
        end
      end
      
      redirect_to({action:'edit'})
    else
      redirect_to({action:'signin'})
    end
  end
  def change_password
    if !session[:id] && !session[:token]
      redirect_to({action:'signin'})
    end
  end
  def update_password
    if session[:id] && session[:token]
      params[:user][:session_id] = session[:id]
      params[:user][:session_token] = session[:token]
      data_input = params[:user]
      data_output = ::Utility.send_request_to_host_api("put",DOMAIN_HOST+VERSION_API+"/"+USERS_TABLE+"/"+session[:id].to_s+"/password",data_input)

      if data_output["meta"]["code"].to_i == 200
        flash[:notice] = data_output["meta"]["description"]
      else
        if data_output["meta"]["code"].to_i == 1001       
          flash[:errors] = data_output["meta"]["messages"]
        else
          flash[:error] = data_output["meta"]["description"]
        end  
      end
      redirect_to({action:'change_password'})
    else
      redirect_to({action:'signin'})
    end
  end

  def search
    @keyword = (params[:user][:keyword] rescue "")
    @page = (params[:page].to_s rescue "")
    @per_page = (params[:per_page].to_s rescue "")
    result = ::Utility.send_request_to_host_api("get",DOMAIN_HOST+VERSION_API+"/"+USERS_TABLE+"/search/?"+KEYWORD+"="+@keyword+"&"+PAGE+"="+@page+"&"+PER_PAGE+"="+@per_page)
    @data_view = result["data"]["source"]
    @pagination = result["data"]["pagination"]
  end

  def post
    @page = (params[:page] rescue "")
    @per_page = (params[:per_page] rescue "")
    @order = (params[:order] rescue "")
    @id = (params[:id])

    if !(@id.present?) || @id == "" || @id.nil?
      redirect_to({action:'all',controller:'posts'})
    end

    data_output = ::Utility.send_request_to_host_api("get",DOMAIN_HOST+VERSION_API+"/"+USERS_TABLE+"/"+@id.to_s+"/posts_status_true/?"+PAGE+"="+@page.to_s+"&"+PER_PAGE+"="+@per_page.to_s+"&"+ORDER+"="+@order.to_s)
    if data_output["meta"]["code"].to_i == 200
      @data_view = data_output["data"]["source"]
      @pagination = data_output["data"]["pagination"]
    else
      @error = data_output["meta"]["description"]
    end 
  end

  def login
    params[:user][:session_id] = session[:id]
    params[:user][:session_token] = session[:token]
    data_input = params[:user]
    data_output = ::Utility.send_request_to_host_api("post",DOMAIN_HOST+VERSION_API+"/"+USERS_TABLE+"/login",data_input)
  
    if data_output["meta"]["code"].to_i == 200
      session[:id] = data_output["data"]["id"]
      session[:token] = data_output["data"]["token"]
      redirect_to({controller: 'posts', action:'index'})
    else
      flash[:error] = data_output["meta"]["description"]
      redirect_to({action:'signin'})
    end
  end

  def logout
    if !session[:id] && !session[:token]
      redirect_to({action:'signin'})
      return false
    end
    data_output = ::Utility.send_request_to_host_api("post",DOMAIN_HOST+VERSION_API+"/"+USERS_TABLE+"/logout",{session_id:session[:id]})
    if data_output["meta"]["code"].to_i == 200
      session.clear
      flash[:notice] = data_output["meta"]["description"]
      redirect_to({action:'signin'})
    else
      flash[:errors] = data_output["meta"]["description"]
      redirect_to({controller: 'posts', action:'index'})
    end
    
  end
end

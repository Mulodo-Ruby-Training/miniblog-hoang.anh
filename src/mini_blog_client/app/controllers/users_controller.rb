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
      response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/users/'+session[:id].to_s))
      data_output = JSON.parse(response)
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
      if params[:user]["birthday(1i)"] !="" && params[:user]["birthday(2i)"] != "" && params[:user]["birthday(3i)"] != ""
        params[:user][:birthday] = Date.civil(params[:user]["birthday(1i)"].to_i,params[:user]["birthday(2i)"].to_i,params[:user]["birthday(3i)"].to_i)
      end
      params[:user][:session_id] = session[:id]
      params[:user][:session_token] = session[:token]
      data_input = params[:user]
      uri = URI.parse('http://localhost:3000/v1/users/'+session[:id].to_s)
      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Put.new(uri.path)
      request.set_form_data(data_input)
      response = http.request(request)
      data_output = JSON.parse(response.body)
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
      uri = URI.parse('http://localhost:3000/v1/users/'+session[:id].to_s+'/password')
      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Put.new(uri.path)
      request.set_form_data(data_input)
      response = http.request(request)
      data_output = JSON.parse(response.body)
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
    response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/users/search/?keyword='+@keyword+
      '&page='+@page+'&per_page='+@per_page))
    result = JSON.parse(response)
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

    response = Net::HTTP.get(URI.parse("http://localhost:3000/v1/users/#{@id}/posts?page=#{@page}&per_page=#{@per_page}&order=#{@order}"))
    data_output = JSON.parse(response)
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
    resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users/login'),data_input)
    data_output = JSON.parse(resp.body)
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
    resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users/logout'),
      {session_id:session[:id]})
    data_output = JSON.parse(resp.body)
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

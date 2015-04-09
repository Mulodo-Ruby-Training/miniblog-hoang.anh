class PostsController < ApplicationController
  def index
    response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/posts?limit=10'))
    data_output = JSON.parse(response)
    if data_output["meta"]["code"].to_i == 200
      @data_view = data_output["data"]["source"]
    else
      @error = data_output["meta"]["description"]
    end
  end

  def all
    @page = (params[:page] rescue "")
    @per_page = (params[:per_page] rescue "")
    @order = (params[:order] rescue "")

    response = Net::HTTP.get(URI.parse("http://localhost:3000/v1/posts?page=#{@page}&per_page=#{@per_page}&order=#{@order}"))
    data_output = JSON.parse(response)
    if data_output["meta"]["code"].to_i == 200
      @data_view = data_output["data"]["source"]
      @pagination = data_output["data"]["pagination"]
    else
      @error = data_output["meta"]["description"]
    end
    
  end

  def manage
    if !session[:id] && !session[:token]
      redirect_to({controller:'users',action:'signin'})
    end

    id = session[:id]
    @page = params[:page]
    @per_page = params[:per_page]
    @keyword_posts = params[:keyword_posts]
    if !@keyword_posts.nil? || @keyword_posts.present?
      response = Net::HTTP.get(URI.parse("http://localhost:3000/v1/posts/search/?id=#{id}&keyword=#{@keyword_posts}&page=#{@page}&per_page=#{@per_page}"))
    else
      response = Net::HTTP.get(URI.parse("http://localhost:3000/v1/users/#{id}/posts?page=#{@page}&per_page=#{@per_page}"))
    end
    data_output = JSON.parse(response)
    if data_output["meta"]["code"].to_i == 200
      @data_view = data_output["data"]["source"]
      @pagination = data_output["data"]["pagination"]
    else
      @error = data_output["meta"]["description"]
    end 

  end

  def detail
    response = Net::HTTP.get(URI.parse("http://localhost:3000/v1/posts/"+params[:id].to_s))
    data_output = JSON.parse(response)
    if data_output["meta"]["code"].to_i == 200
      @data_view = data_output["data"]
    else
      @error = data_output["meta"]["description"]
    end 
  end

  #function to build UI create post
  def new
    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
    end
  end

  # function to call API create a new post
  def create
    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
    end

    params[:post][:session_id] = session[:id]
    params[:post][:session_token] = session[:token]
    data_input = params[:post]
    resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/posts'),data_input)
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
    redirect_to({action:'new'})
  end

  def edit
    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
    else
      post_id = params[:id]
      user_id = session[:id]

      response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/posts/'+post_id.to_s))
      data_output = JSON.parse(response)

      if data_output["meta"]["code"].to_i != 200
        redirect_to({action:'index'})
        return false
      end

      if data_output["data"]["user_id"] != user_id
        redirect_to({action:'index'})
        return false
      end

      @data_view = data_output["data"]
    end
  end

  def update
    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
    end

    params[:post][:session_id] = session[:id]
    params[:post][:session_token] = session[:token]
    post_id = params[:id]
    data_input = params[:post]

    uri = URI.parse('http://localhost:3000/v1/posts/'+post_id.to_s)
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
    redirect_to({action:'edit',id:post_id})

  end

  def delete

    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
    end
    
    post_id = params[:post][:post_id]
    params[:post][:session_id] = session[:id]
    params[:post][:session_token] = session[:token]

    data_input = params[:post]
    uri = URI.parse('http://localhost:3000/v1/posts/'+post_id.to_s)
    http = Net::HTTP.new(uri.host,uri.port)
    request = Net::HTTP::Delete.new(uri.path)
    request.set_form_data(data_input)
    response = http.request(request)
    data_output = JSON.parse(response.body)

    if data_output["meta"]["code"].to_i == 200
      flash[:notice] = data_output["meta"]["description"]
    else
      flash[:error] = data_output["meta"]["description"]
    end
    redirect_to({action:'manage'})

  end
end

class PostsController < ApplicationController
  def index
    page = params[:page]
    per_page = params[:per_page]
    order = params[:order]
    data_output = ::Utility.send_request_to_host_api("get",DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE+"?"+LIMIT+"=10&"+PAGE+"="+page.to_s+"&"+PER_PAGE+"="+per_page.to_s+"&"+ORDER+"="+order.to_s)
    if data_output["meta"]["code"].to_i == 200
      @data_view = data_output["data"]["source"]
    else
      @error = data_output["meta"]["description"]
    end
  end

  def all
    @page = params[:page]
    @per_page = params[:per_page]
    @order = params[:order]

    # response = Net::HTTP.get(URI.parse("http://localhost:3000/v1/posts?page=#{@page}&per_page=#{@per_page}&order=#{@order}"))
    # data_output = JSON.parse(response)
    data_output = ::Utility.send_request_to_host_api("get",DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE+"?"+PAGE+"="+@page.to_s+"&"+PER_PAGE+"="+@per_page.to_s+"&"+ORDER+"="+@order.to_s)
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
      response = Net::HTTP.get(URI.parse(DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE+"/search/?"+ID+"="+id.to_s+"&"+KEYWORD+"="+@keyword_posts.to_s+"&"+PAGE+"="+@page.to_s+"&"+PER_PAGE+"="+@per_page.to_s))
    else
      response = Net::HTTP.get(URI.parse(DOMAIN_HOST+VERSION_API+"/"+USERS_TABLE+"/"+id.to_s+"/"+POSTS_TABLE+"?"+PAGE+"="+@page.to_s+"&"+PER_PAGE+"="+@per_page.to_s))
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
    if !request.xhr?
      data_output = ::Utility.send_request_to_host_api("get",DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE+"/"+params[:id].to_s)
      
      if data_output["data"][0].nil? || data_output["data"][0]["status"] == false
        redirect_to({action:'index'})
        return false
      end

      if data_output["meta"]["code"].to_i == 200
        @data_view = data_output["data"]
      end

      data_output = ::Utility.send_request_to_host_api("get",DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE+"/"+params[:id].to_s+"/"+COMMENTS_TABLE)
      if data_output["meta"]["code"].to_i == 200
        @data_view2 = data_output["data"]["source"]
        @pagination = data_output["data"]["pagination"]
      end
    else
      data_output = ::Utility.send_request_to_host_api("get",DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE+"/"+params[:id].to_s+"/"+COMMENTS_TABLE+"?"+PAGE+"="+params[:page].to_s)
      render json:data_output
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

    if params[:post][:image]
      url_image = Post::upload(params[:post][:image])
      if url_image != false
        string_encode = Base64.encode64(File.open(Rails.root.to_s + "/public" + url_image.to_s,"rb").read)
        original_image = params[:post][:image].original_filename
        params[:post][:image] = string_encode
        params[:post][:name_original_image] = original_image
        # File.delete(Rails.root.to_s + "/public" + url_image.to_s)
      end
    end
    
    params[:post][:session_id] = session[:id]
    params[:post][:session_token] = session[:token]
    data_input = params[:post]
    data_output = ::Utility.send_request_to_host_api("post",DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE,data_input)

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
      data_output = ::Utility.send_request_to_host_api("get",DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE+"/"+post_id.to_s)

      if data_output["meta"]["code"].to_i != 200 || data_output["data"][0]["user_id"] != user_id
        redirect_to({action:'index'})
        return false
      end

      @data_view = data_output["data"][0]
    end
  end

  def update
    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
      return false
    end

    if params[:post][:image]
      url_image = Post::upload(params[:post][:image])
      if url_image != false
        string_encode = Base64.encode64(File.open(Rails.root.to_s + "/public" + url_image.to_s,"rb").read)
        original_image = params[:post][:image].original_filename
        params[:post][:image] = string_encode
        params[:post][:name_original_image] = original_image
        # File.delete(Rails.root.to_s + "/public" + url_image.to_s)
      end
    end

    params[:post][:session_id] = session[:id]
    params[:post][:session_token] = session[:token]
    post_id = params[:id]
    data_input = params[:post]
    data_output = ::Utility.send_request_to_host_api("put",DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE+"/"+post_id.to_s,data_input)

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
    data_output = ::Utility.send_request_to_host_api("delete",DOMAIN_HOST+VERSION_API+"/"+POSTS_TABLE+"/"+post_id.to_s,data_input)

    if data_output["meta"]["code"].to_i == 200
      flash[:notice] = data_output["meta"]["description"]
    else
      flash[:error] = data_output["meta"]["description"]
    end
    redirect_to({action:'manage'})

  end
end

class CommentsController < ApplicationController
  def create
    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
    end

    params[:comment][:session_id] = session[:id]
    params[:comment][:session_token] = session[:token]
    params[:comment][:post_id] = params[:id]
    data_input = params[:comment]
    data_output = ::Utility.send_request_to_host_api("post",DOMAIN_HOST+VERSION_API+"/"+COMMENTS_TABLE,data_input)

    if data_output["meta"]["code"].to_i == 1001
      flash[:errors] = data_output["meta"]["messages"]
    else
      if data_output["meta"]["code"].to_i == 200
        flash[:notice] = data_output["meta"]["description"]
      else
        flash[:error] = data_output["meta"]["description"]
      end
    end
    redirect_to({action:'detail',controller:'posts',id:params[:id]})
  end

  def update
    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
    end

    params[:comment][:session_id] = session[:id]
    params[:comment][:session_token] = session[:token]
    params[:comment][:post_id] = params[:id]
    data_input = params[:comment]
    data_output = ::Utility.send_request_to_host_api("put",DOMAIN_HOST+VERSION_API+"/"+COMMENTS_TABLE+"/"+params[:comment][:comment_id].to_s,data_input)

    if data_output["meta"]["code"].to_i == 1001
      flash[:errors] = data_output["meta"]["messages"]
    else
      if data_output["meta"]["code"].to_i == 200
        flash[:notice] = data_output["meta"]["description"]
      else
        flash[:error] = data_output["meta"]["description"]
      end
    end
    redirect_to({action:'detail',controller:'posts',id:params[:id]})
  end

  def delete
    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
    end

    params[:comment][:session_id] = session[:id]
    params[:comment][:session_token] = session[:token]
    params[:comment][:post_id] = params[:id]
    data_input = params[:comment]
    data_output = ::Utility.send_request_to_host_api("delete",DOMAIN_HOST+VERSION_API+"/"+COMMENTS_TABLE+"/"+params[:comment][:comment_id].to_s,data_input)
   
    if data_output["meta"]["code"].to_i == 1001
      flash[:errors] = data_output["meta"]["messages"]
    else
      if data_output["meta"]["code"].to_i == 200
        flash[:notice] = data_output["meta"]["description"]
      else
        flash[:error] = data_output["meta"]["description"]
      end
    end
    redirect_to({action:'detail',controller:'posts',id:params[:id]})
  end

end
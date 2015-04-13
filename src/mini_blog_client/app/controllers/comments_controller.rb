class CommentsController < ApplicationController
  def create
    if !session[:id] && !session[:token]
      redirect_to({controller:'users', action:'signin'})
    end

    params[:comment][:session_id] = session[:id]
    params[:comment][:session_token] = session[:token]
    params[:comment][:post_id] = params[:id]
    data_input = params[:comment]
    resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/comments'),data_input)
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

    uri = URI.parse('http://localhost:3000/v1/comments/'+params[:comment][:comment_id].to_s)
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

    uri = URI.parse('http://localhost:3000/v1/comments/'+params[:comment][:comment_id].to_s)
    http = Net::HTTP.new(uri.host,uri.port)
    request = Net::HTTP::Delete.new(uri.path)
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
    redirect_to({action:'detail',controller:'posts',id:params[:id]})
  end

end
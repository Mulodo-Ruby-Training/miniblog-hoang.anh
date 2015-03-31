class UsersController < ApplicationController
  def create
    params[:user][:birthday] = Date.civil(params[:user]["birthday(1i)"].to_i,params[:user]["birthday(2i)"].to_i,params[:user]["birthday(3i)"].to_i)
    data_input = params[:user]
    resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users'),data_input)
    data_output = JSON.parse(resp.body)
    if data_output["meta"]["code"].to_i == 1001
      flash[:errors] = data_output["meta"]["messages"]
    else
      flash[:notice] = data_output["meta"]["description"]
    end
    
    # flash[:notice] = data_input
    redirect_to({action:'signup'})
  end
end

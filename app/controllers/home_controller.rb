class HomeController < ApplicationController
  def index
    @user = session[:user]
    
    if session[:user]
  		if User.admin?(@user) 
  			redirect_to("/admin") 
  		else 
  			redirect_to user_path(@user)
  		end
  	end
  end
  
  def admin
    @user = session[:user]
    @users = User.all
  end
end

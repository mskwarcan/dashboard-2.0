class HomeController < ApplicationController
  before_filter :is_admin, :only => :admin
  
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
    @users = User.all(:conditions => ["username != 'admin'"], :order => "client ASC")
  end
  
  def forgot
    
  end
end

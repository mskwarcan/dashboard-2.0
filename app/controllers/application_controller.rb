class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def is_admin
    if session[:user]
      if !User.admin?(session[:user])
        flash[:error] = 'You do not have permission to access that page.'
        respond_to do |format|
          format.html { redirect_to("/") and return}
        end
      end
    else
      flash[:error] = 'You do not have permission to access that page.'
      respond_to do |format|
        format.html { redirect_to("/") and return}
      end
    end
  end
  
  def current_user
    if !User.admin?(session[:user])
      if(!session[:user].id == params[:id])
        flash[:error] = 'You do not have permission to access that page.'
        respond_to do |format|
          format.html { redirect_to("/") and return}
        end
      end
    end
  end
end

class UsersController < ApplicationController
  require "rubygems"
  require 'twitter_oauth'
  require 'linkedin'
  require 'fbgraph'
  require 'twitter'
  require 'gattica'
  
  before_filter :is_admin, :except => [:show, :logout, :authenticate, :forgot]
  before_filter :current_user, :only => :show

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to("/admin", :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to("/admin") }
      format.xml  { head :ok }
    end
  end
  
  def logout
    session[:user] = nil
    redirect_to ("/")
  end
  
  def authenticate
    @user = User.first(:conditions => {:username => params[:username], :password => params[:password]})
    
    if(@user)
      session[:user] = @user
        respond_to do |format|
          format.html { redirect_to("/") }
          format.xml  { head :ok }
        end
    else
      flash[:error] = "Incorrect Username or Password"
      respond_to do |format|
        format.html { redirect_to "/" }
        format.xml  { head :ok }
      end
    end
  end
  
  def forgot
    @user = User.first(:conditions => {:username => params[:username]})
    
    Forgot.forgot_password(@user).deliver
    if @user
      flash[:success] = "Your password has been sent"
      respond_to do |format|
        format.html { redirect_to "/forgot"}
        format.xml  { head :ok }
      end
    else
      flash[:error] = "That user doesn't exist"
      respond_to do |format|
        format.html { redirect_to "/forgot"}
        format.xml  { head :ok }
      end
    end
  end
  
  def facebook_id
    @user = User.first(:conditions => {:username => params[:user]})
    session[:client] = @user
    
    #Set client up
    client = User.facebook
    
    @user.facebook_token = params[:id]
    @user.fb_authenticated = true
    @user.facebook_monthly_count = client.selection.page(params[:id]).info!["likes"]
    @user.save
    
    redirect_to "/"
  end
  
  def twitter_register
    #Get user
    @user = User.first(:conditions => {:username => params[:user]})
    session[:client] = @user
    
    #Set client up
    client = User.twitter(@user)
    
    request_token = client.request_token( :oauth_callback => 'http://bdashd.com/twitter_oauth' )
    @user.twitter_token = request_token.token
    @user.twitter_secret = request_token.secret
    @user.save
    redirect_to request_token.authorize_url
  end
  
  def twitter_oauth
    @user = session[:client]
    
    #Set client up
    client = User.twitter(@user)
    
     access_token = client.authorize(
       @user.twitter_token,
       @user.twitter_secret,
       :oauth_verifier => params[:oauth_verifier]
     )
     
     @user.twitter_token = access_token.token
     @user.twitter_secret = access_token.secret
     @user.twitter_authenticated = true
     @user.twitter_monthly_count = client.info["followers_count"]
     @user.save
     
     redirect_to "/"
   end
   
   def analytics
     @user = User.first(:conditions => {:username => params[:user]})
     
     @user.analytics_authenticated = true
     @user.analytics = params[:id]
     @user.save
     
     redirect_to "/"
   end
   
   def mailchimp
     @user = User.first(:conditions => {:username => params[:user]})
     
     @user.mailchimp_authenticated = true
     @user.mailchimp = params[:id]
     @user.save
     
     redirect_to "/"
   end
end

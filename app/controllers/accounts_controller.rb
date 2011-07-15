class AccountsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
    
    get_account_lists(@account)
  end
  
  def update_lists
    @account = Account.find(params[:id])
    
    profile_list = AccountList.where(:account_id => @account.id)
    
    profile_list.each do |profile|
      profile.destroy
    end
    
    if(@account.google_token)
      @account.get_analytic_profiles
    end
    
    if(@account.facebook_token)
      @account.get_facebook_profiles
    end
    
    if(@account.mailchimp_api_key)
      @account.get_mailchimp_lists
    end
    
    respond_to do |format|
      format.html { redirect_to :action => "edit" }
    end
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])
    @account.users << current_user
    
    respond_to do |format|
      if @account.save
        AccountsUser.admin(current_user.id, @account.id)
        if(!@account.mailchimp_api_key.empty?)
          @account.get_mailchimp_lists
        end
        format.html { redirect_to(@account, :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to(@account, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to("/accounts") }
      format.xml  { head :ok }
    end
  end
  
  def facebook_register
    #Set client up
    client = Account.facebook
    
    callback_url = "http://social-dashboard.heroku.com/facebook_callback"
    
    redirect_to client.authorization.authorize_url(:redirect_uri => callback_url , :scope => 'manage_pages, offline_access')
  end
  
  def facebook_callback
    #Set client up
    client = Account.facebook
    
    callback_url = "http://social-dashboard.heroku.com/facebook_callback"
    
    #Convert the request token to an access token
    access_token = client.authorization.process_callback(params[:code], :redirect_uri => callback_url)
    
    account = Account.get_account(session[:account_id])

    account.facebook_token = access_token
    account.save
    
    account.get_facebook_profiles
     
    redirect_to '/' 
  end
  
  def twitter_register
    #Set client up
    client = Account.twitter
    
    callback_url = "http://social-dashboard.heroku.com/twitter_callback"
    
    #Request a token and authorize
    request_token = client.get_request_token(:oauth_callback => callback_url)
    session[:request_token] = request_token
    redirect_to request_token.authorize_url
  end
  
  def twitter_callback
    client = Account.twitter

    # Re-create the request token
    request_token = OAuth::RequestToken.new(client, session[:request_token].token, session[:request_token].secret)

    # Convert the request token to an access token using the verifier Twitter gave us
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

    # Store the token and secret that we need to make API calls
    
    account = Account.get_account(session[:account_id])
    
    account.twitter_token = access_token.token
    account.twitter_secret = access_token.secret
    account.twitter
    account.twitter_name = Twitter.user["screen_name"]
    account.save
    
    # Hand off to our app, which actually uses the API with the above token and secret
    redirect_to '/'
    
   end
   
   def google_register
     #Set client up
     client = Account.google
     
     #Request a token and authorize
     request_token = client.get_request_token({:oauth_callback => "http://social-dashboard.heroku.com/google_callback"}, {:scope => 'https://www.google.com/analytics/feeds'})
     session[:request_token] = request_token
     redirect_to request_token.authorize_url
   end
   
   def google_callback
     client = Account.google

     # Re-create the request token
     request_token = OAuth::RequestToken.new(client, session[:request_token].token, session[:request_token].secret)

     # Convert the request token to an access token using the verifier Google gave us
     access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

     # Store the token and secret that we need to make API calls

     account = Account.get_account(session[:account_id])

     account.google_token = access_token.token
     account.google_secret = access_token.secret
     account.save
     
     account.get_analytic_profiles

     # Hand off to our app, which actually uses the API with the above token and secret
     redirect_to '/'
   end
   
   def remove_google
     account = Account.find(params[:id])
     
     #Remove Accounts from Account List
     @google_profiles = AccountList.where(:account_id => account.id, :profile_type => 'google')
     @google_profiles.delete_all
     
     #Remove Token/Secret/google_profile_id
     account.google_profile_id = nil
     account.google_token = nil
     account.google_secret = nil
     account.save
     
     respond_to do |format|
       format.html { redirect_to :action => "edit" }
     end
   end
   
   def remove_twitter
     account = Account.find(params[:id])
     account.twitter_name = nil
     account.twitter_token = nil
     account.twitter_secret = nil
     account.save
     
     respond_to do |format|
       format.html { redirect_to :action => "edit" }
     end
   end
   
   def remove_facebook
     account = Account.find(params[:id])
     
     #Remove Accounts from Account List
     @profiles = AccountList.where(:account_id => account.id, :profile_type => 'facebook')
     @profiles.delete_all
     
     account.facebook_profile_id = nil
     account.facebook_token = nil
     account.save
     
     respond_to do |format|
       format.html { redirect_to :action => "edit" }
     end
   end
   
   def remove_mailchimp
     account = Account.find(params[:id])
     
     #Remove Accounts from Account List
     @profiles = AccountList.where(:account_id => account.id, :profile_type => 'mailchimp')
     @profiles.delete_all
     
     account.mailchimp_list_id = nil
     account.mailchimp_api_key = nil
     account.save
     
     respond_to do |format|
       format.html { redirect_to :action => "edit" }
     end
   end
   
   protected
   def get_account_lists(account)
     if(account.google_token)
       @google_profile = Account.get_profile_name(account.google_profile_id,'google')
       @google_profiles = AccountList.where(:account_id => account.id, :profile_type => 'google')
     end

     if(account.facebook_token)
       @facebook_profile = Account.get_profile_name(account.facebook_profile_id, 'facebook')
       @facebook_profiles = AccountList.where(:account_id => account.id, :profile_type => 'facebook')
     end

     if(!account.mailchimp_api_key.to_s.empty?)
       @mailchimp_profile = Account.get_profile_name(account.mailchimp_list_id, 'mailchimp')
       @mailchimp_lists = AccountList.where(:account_id => account.id, :profile_type => 'mailchimp')
     end
   end
end

class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin, :except => [:index, :show, :new, :create, :add_connection, :remove_connection]
  
  # GET /accounts
  # GET /accounts.xml
  def index
    @admin_accounts = AccountsUser.where(:user_id => current_user.id, :access => 'admin', :status => 'confirmed').includes(:account).collect{|au| au.account}
    @viewer_accounts = AccountsUser.where(:user_id => current_user.id, :access => 'viewer', :status => 'confirmed').includes(:account).collect{|au| au.account}
    @connections = AccountsUser.where(:user_id => current_user.id, :status => 'confirmed')
    @pending_connections = AccountsUser.where(:user_id => current_user.id, :status => 'pending')

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
        @account.accounts_users.last.status = "confirmed"
        @account.accounts_users.last.access = "admin"
        @account.accounts_users.last.save
        
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
     
    redirect_to "/accounts/#{session[:account_id]}/edit"
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
    redirect_to "/accounts/#{session[:account_id]}/edit"
    
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
     redirect_to "/accounts/#{session[:account_id]}/edit"
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
   
   def users
     @account = Account.get_account(params[:id])
     @account_users = @account.accounts_users
     
     respond_to do |format|
       format.html # add_users.html.erb
     end
   end
   
   def add_user
     @account = Account.get_account(params[:id])
     @user = User.first(:conditions => {:email => params[:email]})
     
     if @user.nil?
      redirect_to("/accounts/#{@account.id}/users", :notice => 'An account with that email adress does not exist.')
     else
       begin
         @account.users << @user
          @account.save       
          @account.accounts_users.last.status = params[:access]
          @account.accounts_users.last.save
          redirect_to("/accounts/#{@account.id}/users", :notice => "You have added #{params[:email]} to the list of users. Confirmation is pending.")
       rescue ActiveRecord::RecordInvalid
         respond_to do |format|
           format.html { redirect_to "/accounts/#{@account.id}/users", :notice => 'That user is already tied to that account.'}
           format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
         end
       end  
     end
   end
   
   def add_connection
     @connection = AccountsUser.first(:conditions => {:account_id => params[:id], :user_id => current_user.id})
     @connection.status = 'confirmed'
     @connection.save
     
     redirect_to "/"
   end
   
   def remove_connection
     @connection = AccountsUser.first(:conditions => {:account_id => params[:id], :user_id => current_user.id})
     @connection.destroy
     
     redirect_to "/"
   end
   
   protected
   def get_account_lists(account)
     if(account.google_token)
       if(account.google_profile_id)
         @google_profile = Account.get_profile_name(account.google_profile_id,'google')
       end
       @google_profiles = AccountList.where(:account_id => account.id, :profile_type => 'google')
     end

     if(account.facebook_token)
       if(account.facebook_profile_id)
         @facebook_profile = Account.get_profile_name(account.facebook_profile_id, 'facebook')
        end
       @facebook_profiles = AccountList.where(:account_id => account.id, :profile_type => 'facebook')
     end

     if(!account.mailchimp_api_key.to_s.empty?)
       if(account.mailchimp_list_id)
         @mailchimp_profile = Account.get_profile_name(account.mailchimp_list_id, 'mailchimp')
       end
       @mailchimp_lists = AccountList.where(:account_id => account.id, :profile_type => 'mailchimp')
     end
   end
   
   private
   def verify_admin
     @account = Account.find(params[:id])
     admin = AccountsUser.first(:conditions => {:user_id => current_user.id, :account_id => @account.id, :status => 'confirmed', :access => 'admin'})
     
     if (admin.nil?)
       respond_to do |format|
         format.html { redirect_to "/", :notice => 'You do not have permission to view that page.'}
         format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
       end
     end
   end
end

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
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
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
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  def twitter_register
    session[:account_id] = params[:id]
    
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
    
    account.twitter_token = @access_token.token
    account.twitter_secret = @access_token.secret
    account.save

    # Hand off to our app, which actually uses the API with the above token and secret
    redirect_to '/'
    
   end
end

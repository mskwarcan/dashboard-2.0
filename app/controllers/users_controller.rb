class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

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
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
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
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def upgrade
    @card = CreditCard.new
    
    respond_to do |format|
      format.html { render "shared/upgrade"}
      format.xml  { render :xml => @user }
    end
  end
  
  def process_card
    @user = current_user
    @card = CreditCard.new(params[:credit_card])
    
    # Send requests to the gateway's test servers
    ActiveMerchant::Billing::Base.mode = :test
    
    if @card.save
      # Create a new credit card object
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :type       => @card.card_type,
        :number     => @card.number,
        :month      => @card.month,
        :year       => @card.year,
        :first_name => @card.first_name,
        :last_name  => @card.last_name,
        :verification_value  => @card.ccv
      )

      if credit_card.valid?
        # Create a gateway object to the TrustCommerce service
        gateway = ActiveMerchant::Billing::Base.gateway(:pay_junction).new(
                      :login => "my_account", 
                      :password => "my_pass"
                   )

        # Authorize for $10 dollars (1000 cents)
        response = gateway.authorize(params[:tier].to_i, credit_card)

        if response.success?
          # Capture the money
          gateway.capture(params[:tier].to_i, response.authorization)
          current_user.type_of_user = params[:tier]
          current_user.save
        
          respond_to do |format|
            format.html { redirect_to("/accounts", :notice => "Your account has been updated.")}
            format.xml  { render :xml => @user }
          end
        else
          raise StandardError, response.message
          respond_to do |format|
            flash[:alert] = response.message
            format.html { render "shared/upgrade"}
            format.xml  { render :xml => @user }
          end
        end
      else
        respond_to do |format|
          flash[:alert] = 'Invalid Credit Card'
          format.html { render "shared/upgrade"}
          format.xml  { render :xml => @user }
        end
      end
    else
       respond_to do |format|
        format.html { render "shared/upgrade" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
       end
    end
  end
  
end

class User < ActiveRecord::Base
  validates :username,  :presence => true,
                        :length => { :minimum => 5},
                        :uniqueness => true
  validates :password,  :presence => true,
                        :length => { :minimum => 6}
  validates :client,  :presence => true,
                      :uniqueness => true
  validates :email,  :presence => true
  
  def twitter_authd?(user)
    @user = User.first(:conditions => {:username => user.username})
    if @user.twitter_authenticated == true
      return true
    end
  end
  
  def linkedin_authd?(user)
    @user = User.first(:conditions => {:username => user.username})
    if @user.linkedin_authenticated == true
      return true
    end
  end
  
  def facebook_authd?(user)
    @user = User.first(:conditions => {:username => user.username})
    if @user.facebook_authenticated == true
      return true
    end
  end
  
  def self.admin?(user)
    @user = user
    
    if(@user.username == 'admin')
      return true
    end
  end
  
  private
  def self.twitter(user)
    @user = user
    
    TwitterOAuth::Client.new(
    :consumer_key => 'jQi9EznIOf3K71DT2IfPcg',
    :consumer_secret => 'el3znAVtSqE8atVwWP4Mml7UgovlKXVZi7Ih57c',
    :token => @user.twitter_token,
    :secret => @user.twitter_secret
    )
  end
  
  def self.facebook(user)
    @user = user

   	FacebookOAuth::Client.new(
         :application_id => '185181124851176',
         :application_secret => '9ebcc080254926b191aaba84023743f8',
         :token => @user.facebook_token
    )
 end 
  
end

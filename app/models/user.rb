require 'digest/sha2'

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
  
  def google_authd?(user)
    @user = User.first(:conditions => {:username => user.username})
    if @user.analytics_authenticated == true
      return true
    end
  end
  
  def facebook_authd?(user)
    @user = User.first(:conditions => {:username => user.username})
    if @user.fb_authenticated == true
      return true
    end
  end
  
  def mailchimp_authd?(user)
    @user = User.first(:conditions => {:username => user.username})
    if @user.mailchimp_authenticated == true
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
  
  def self.facebook
   	FBGraph::Client.new(:client_id => '185181124851176',:secret_id =>'9ebcc080254926b191aaba84023743f8', :token => '185181124851176|46007d4a346e034c1b64bcb2.1-301500211|NBQs7yhG13wmmHq63w9u8FAIXQ8')
 end
  
  def self.google
    Gattica.new({:email => 'mskwarca@purdue.edu', :password => '777lucky'})
  end
end

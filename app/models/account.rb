class Account < ActiveRecord::Base
  require "open-uri"
  
  has_many :users, :through => :accounts_users
  has_many :accounts_users
  has_many :updates
  
  def self.get_account(id)
    Account.first(:conditions => {:id => id})
  end
  
  def self.get_profile_name(profile_id, type)
    profile = AccountList.first(:conditions => {:profile_id => profile_id, :profile_type => type})
    return profile.profile_name
  end
  
  def get_analytic_profiles
    #get client
    client = Account.google
    at = OAuth::AccessToken.new(client, google_token, google_secret)
    
    #return a hash from the xml
    profiles = Hash.from_xml(at.get("https://www.google.com/analytics/feeds/accounts/default?prettyprint=true").body)
    
    profiles["feed"]["entry"].each do |entry|
      analytic_profile = AccountList.new
      analytic_profile.account_id = id
      analytic_profile.profile_id = entry["property"][2]["value"]
      analytic_profile.profile_name = entry["title"]
      analytic_profile.profile_type = "google"
      analytic_profile.save
    end
  end
  
  def get_analytics_data(token, start_date, end_date)
    analytics = Hash.from_xml(token.get("https://www.google.com/analytics/feeds/data?ids=ga:#{google_profile_id}&start-date=#{start_date}&end-date=#{end_date}&metrics=ga:pageviews,ga:uniquePageviews,ga:avgTimeOnSite,ga:newVisits,ga:visits,ga:goalCompletionsAll&prettyprint=true").body)
    analytics_hash = analytics["feed"]["entry"]["metric"]
    adwords = Hash.from_xml(token.get("https://www.google.com/analytics/feeds/data?ids=ga:#{google_profile_id}&start-date=#{start_date}&end-date=#{end_date}&metrics=ga:impressions,ga:adClicks,ga:CTR,ga:CPC,ga:costPerConversion,ga:adCost,ga:transactions&prettyprint=true").body)
    adwords_hash = adwords["feed"]["entry"]["metric"]
    complete_analytics = (analytics_hash + adwords_hash)
  end
  
  def get_facebook_profiles
    client = Account.facebook(facebook_token)
    
    client.me('accounts').each do |account|
      facebook_profile = AccountList.new
      facebook_profile.account_id = id
      facebook_profile.profile_id = account["id"]
      facebook_profile.profile_name = account["name"]
      facebook_profile.profile_type = "facebook"
      facebook_profile.save
    end
  end
  
  def get_mailchimp_lists
    client = Hominid::API.new(mailchimp_api_key)
    
    client.lists["data"].each do |list|
      mailchimp_profile = AccountList.new
      mailchimp_profile.account_id = id
      mailchimp_profile.profile_id = list["id"]
      mailchimp_profile.profile_name = list["name"]
      mailchimp_profile.profile_type = "mailchimp"
      mailchimp_profile.save
    end
  end
  
  def twitter_init
    Twitter.configure do |config|
      config.consumer_key = 'GeeLSFoDBSRUaXRHLSSiQg'
      config.consumer_secret = 'cSTcJAPIC3enr7Ew5a4mNopOgb2B6srYrhdMrU8Q'
      config.oauth_token = twitter_token
      config.oauth_token_secret = twitter_secret
    end
  end
  
  def twitter_user
    Twitter.user
  end
  
  private
  def self.youtube
    YouTubeIt::OAuthClient.new("GeeLSFoDBSRUaXRHLSSiQg", "cSTcJAPIC3enr7Ew5a4mNopOgb2B6srYrhdMrU8Q")
  end
  
  def self.twitter
    OAuth::Consumer.new("GeeLSFoDBSRUaXRHLSSiQg","cSTcJAPIC3enr7Ew5a4mNopOgb2B6srYrhdMrU8Q", :site => "http://twitter.com") 
  end
  
  def self.google
    OAuth::Consumer.new('social-dashboard.heroku.com', 'yoPYHCsQwf5D53P7ozcvgCsl', {:site => 'https://www.google.com', :request_token_path => '/accounts/OAuthGetRequestToken', :access_token_path => '/accounts/OAuthGetAccessToken',:authorize_path => '/accounts/OAuthAuthorizeToken'}) 
  end
  
  def self.facebook(token = nil)
      FGraph::Client.new(:client_id => '231052250248689', :client_secret => 'f91517dd3a452f2d82a71dfd5c07c458', :access_token => token)
  end
end

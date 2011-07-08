class Account < ActiveRecord::Base
  has_many :users
  belongs_to :users
  
  def self.get_account(id)
    Account.first(:conditions => {:id => id})
  end
  
  def get_analytic_profiles
    #get client
    client = Account.google
    at = OAuth::AccessToken.new(client, google_token, google_secret)
    
    #return a hash from the xml
    profiles = Hash.from_xml(at.get("https://www.google.com/analytics/feeds/accounts/default?prettyprint=true").body)
    
    profile_list = []
    
    profiles["feed"]["entry"].each do |entry|
      profile_list << [entry["title"], entry["property"][2]["value"]]
    end
    
    return profile_list
  end
  
  private
  def self.twitter
    OAuth::Consumer.new("GeeLSFoDBSRUaXRHLSSiQg","cSTcJAPIC3enr7Ew5a4mNopOgb2B6srYrhdMrU8Q", :site => "http://twitter.com") 
  end
  
  def self.google
    OAuth::Consumer.new('social-dashboard.heroku.com', 'yoPYHCsQwf5D53P7ozcvgCsl', {:site => 'https://www.google.com', :request_token_path => '/accounts/OAuthGetRequestToken', :access_token_path => '/accounts/OAuthGetAccessToken',:authorize_path => '/accounts/OAuthAuthorizeToken'}) 
  end
  
  def self.facebook(code)
    app_id = '231052250248689'
    app_secret = 'f91517dd3a452f2d82a71dfd5c07c458'
    my_url = 'http://social-dashbord.heroku.com/'
    
    token_url = "https://graph.facebook.com/oauth/access_token?client_id=" + app_id + "&redirect_uri=" + URI.encode(my_url) + "&client_secret=" + app_secret + "&code=" + code
    
    access_token = open(URI.encode(token_url))
  end
end

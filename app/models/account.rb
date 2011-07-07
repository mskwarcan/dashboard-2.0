class Account < ActiveRecord::Base
  has_many :users
  belongs_to :users
  
  def self.get_account(id)
    Account.first(:conditions => {:id => id})
  end
  
  private
  def self.twitter
    OAuth::Consumer.new("GeeLSFoDBSRUaXRHLSSiQg","cSTcJAPIC3enr7Ew5a4mNopOgb2B6srYrhdMrU8Q", :site => "http://twitter.com") 
  end
end

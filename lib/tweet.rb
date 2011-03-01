class Tweet < Struct.new(:user, :update, :heroku) 
  def perform
    begin
      @update = Update.first(:conditions => {:id => update.id})
    
      client = User.twitter(user)
    
      @update.twit_pic = client.info["profile_image_url"]
      @update.twit_name = client.info["screen_name"]
      @update.followers = client.info["followers_count"]
      @update.new_followers = client.info["followers_count"] - user.twitter_monthly_count
      @update.tweets = ActiveSupport::JSON.encode(client.user_timeline())
      
      @update.tweet_done = true
      
      @update.save
      
      if Time.now.day == 1 && Time.now.hour < 3
        user.twitter_monthly_count = client.info["followers_count"]
        user.save
      end
    
    rescue
      return
    end
    
    if Delayed::Job.count == 1
      heroku.set_workers(ENV["APP_NAME"], 0)
    end
  end    
end

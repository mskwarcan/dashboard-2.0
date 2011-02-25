desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  @users = User.all(:conditions => ["username != 'admin'"], :order => "client ASC")
  
  @users.each do |user|
    @update = Update.new
    
    @update.user_id = user.id
    
    if user.twitter_authd?(user)
      client = User.twitter(user)
      
      @update.twit_pic = client.info["profile_image_url"]
      @update.twit_name = client.info["screen_name"]
      @update.followers = client.info["followers_count"]
      @update.new_followers = client.info["followers_count"] - user.twitter_monthly_count
      @update.tweets = ActiveSupport::JSON.encode(client.user_timeline())
    end

    if user.facebook_authd?(user)
      facebook = User.facebook
      
      page = facebook.selection.page(user.facebook_token)
      
      @update.face_pic = page.picture
      @update.face_name = page.info!["name"]
      @update.likes = page.info!["likes"]
      @update.new_likes = page.info!["likes"] - user.facebook_monthly_count
      @update.feed = ActiveSupport::JSON.encode(page.feed.limit(10).info!["data"])
      
      page.feed.limit(10).info!["data"].each do |feed|
        status = Feed.new
        status.feed_id = feed["id"]
        status.picture = facebook.selection.user(feed["from"]["id"]).picture
        status.link = facebook.selection.user(feed["from"]["id"]).info!["link"]
        
        status.save
      end
    end
    
    if user.google_authd?(user)
      gs = User.google
      
      gs.profile_id = user.analytics
      
      currentMonth = Time.now.strftime('%Y-%m-01')
    	lastMonth = 1.month.ago.strftime("%Y-%m-01")
    	twoMonths = 2.month.ago.strftime("%Y-%m-01")
      
      current = gs.get({:start_date => lastMonth, :end_date => currentMonth, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits']})
      @update.results = ActiveSupport::JSON.encode(current.points.first.metrics)
      last = gs.get({:start_date => twoMonths, :end_date => lastMonth, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits']})
      @update.last_month = ActiveSupport::JSON.encode(last.points.first.metrics)
    end
    
    @update.save
        
  end
  
  if Time.now.day == 1 #first of the month
    users = User.all
    users.each do |user|
      if user.twitter_authd?(user)
        client = User.twitter(user)
        user.twitter_monthly_count = client.info["followers_count"]
        user.save
      end
      if user.facebook_authd?(user)
        client = User.facebook(user)
        user.facebook_monthly_count = client.selection.page(user.facebook_token).info!["likes"]
        user.save
      end
    end
  end
end
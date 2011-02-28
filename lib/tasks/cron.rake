desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  @users = User.all(:conditions => ["username != 'admin'"], :order => "client ASC")
  
  @users.each do |user|
    @update = Update.new
    
    @update.user_id = user.id
    
    @update.save
    heroku = Heroku::Client.new(ENV["HEROKU_EMAIL"], ENV["HEROKU_PASS"])
    heroku.set_workers(ENV["APP_NAME"], 1)
    
    if user.twitter_authd?(user)
      Delayed::Job.enqueue Tweet.new(user, @update, heroku)
    end

    if user.facebook_authd?(user)
      Delayed::Job.enqueue Facebook.new(user, @update, heroku)
    end
    
    if user.google_authd?(user)
      Delayed::Job.enqueue Google.new(user, @update, heroku)
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
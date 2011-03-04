desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  @users = User.all(:conditions => ["username != 'admin'"], :order => "client ASC")
  
  heroku = Heroku::Client.new(ENV["HEROKU_EMAIL"], ENV["HEROKU_PASS"])
  heroku.set_workers(ENV["APP_NAME"], 3)
  
  @users.each do |user|
    
    @update = Update.new
    
    @update.user_id = user.id
    
    @update.save
    
    if user.twitter_authd?(user)
      Delayed::Job.enqueue Tweet.new(user, @update, heroku)
    else  
      @update.tweet_done = true
    end

    if user.facebook_authd?(user)
      Delayed::Job.enqueue Facebook.new(user, @update, heroku)
    else
      @update.face_done = true
    end
    
    if user.google_authd?(user)
      Delayed::Job.enqueue Google.new(user, @update, heroku)
    else
      @update.google_done = true
    end
    
    if user.mailchimp_authd?(user)
      Delayed::Job.enqueue Mailchimp.new(user, @update, heroku)
    else
      @update.chimp_done = true
    end
    
    @update.save
        
  end
  
  
end
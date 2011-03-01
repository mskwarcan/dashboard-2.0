desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  @users = User.all(:conditions => ["username != 'admin'"], :order => "client ASC")
  
  heroku = Heroku::Client.new(ENV["HEROKU_EMAIL"], ENV["HEROKU_PASS"])
  heroku.set_workers(ENV["APP_NAME"], 1)
  
  @users.each do |user|
    
    @update = Update.new
    
    @update.user_id = user.id
    
    @update.save
    
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
  
  
end
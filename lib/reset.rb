class Reset < Struct.new(:user, :heroku) 
  def perform
    begin
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
    rescue
      return
    end
    
    if Delayed::Job.count == 1
      heroku.set_workers(ENV["APP_NAME"], 0)
    end
  end    
end


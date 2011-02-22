desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
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
        user.facebook_monthly_count = client.selection.page(@user.facebook_token).info!["likes"]
        user.save
      end
    end
  end
end
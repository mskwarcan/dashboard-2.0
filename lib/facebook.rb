class Facebook < Struct.new(:user, :update, :heroku) 
  def perform
    begin
      @update = Update.first(:conditions => {:id => update.id})
    
      facebook = User.facebook
    
      page = facebook.selection.page(user.facebook_token)
    
      @update.face_pic = page.picture
      @update.face_name = page.info!["name"]
      @update.likes = page.info!["likes"]
      @update.new_likes = page.info!["likes"] - user.facebook_monthly_count
      @update.feed = ActiveSupport::JSON.encode(page.posts.limit(10).info!["data"])
      
      @update.face_done = true
    
      @update.save
      
      if Time.now.day == 1 && Time.now.hour < 3
        user.facebook_monthly_count = facebook.selection.page(user.facebook_token).info!["likes"]
        user.save
      end
    
      page.posts.limit(10).info!["data"].each do |feed|
        status = Feed.new
        status.feed_id = feed["id"]
        status.picture = facebook.selection.user(feed["from"]["id"]).picture
        status.link = facebook.selection.user(feed["from"]["id"]).info!["link"]
      
        status.save
      end
    rescue
      return
    end
    
    if ENV["RAILS_ENV"] == 'production'
      if Delayed::Job.count == 1
        heroku.set_workers(ENV["APP_NAME"], 0)
      end
    end
  end    
end

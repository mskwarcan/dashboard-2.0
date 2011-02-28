class Facebook < Struct.new(:user, :update, :heroku) 
  def perform
    @update = Update.first(:conditions => {:id => update.id})
    
    facebook = User.facebook
    
    page = facebook.selection.page(user.facebook_token)
    
    @update.face_pic = page.picture
    @update.face_name = page.info!["name"]
    @update.likes = page.info!["likes"]
    @update.new_likes = page.info!["likes"] - user.facebook_monthly_count
    @update.feed = ActiveSupport::JSON.encode(page.feed.limit(10).info!["data"])
    
    @update.save
    
    page.feed.limit(10).info!["data"].each do |feed|
      status = Feed.new
      status.feed_id = feed["id"]
      status.picture = facebook.selection.user(feed["from"]["id"]).picture
      status.link = facebook.selection.user(feed["from"]["id"]).info!["link"]
      
      status.save
    end
    
    if Delayed::Job.count == 0
      heroku.set_workers(ENV["APP_NAME"], 0)
    end
  end    
end

class Mailchimp < Struct.new(:user, :update, :heroku) 
  def perform
    begin
      @update = Update.first(:conditions => {:id => update.id})
    
      h = Hominid::API.new(user.mailchimp)
      
      list_id = h.lists.first.second.first["id"]
      @update.chimp_name = h.lists.first.second.first["name"]
      @update.growth = ActiveSupport::JSON.encode(h.list_growth_history(list_id))
      @update.campaign = ActiveSupport::JSON.encode(h.campaigns["data"].first)
      @update.stats = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns["data"].first["id"]))
      
      @update.chimp_done = true
    
      @update.save
      
    rescue
      return
    end
    
    if Delayed::Job.count == 1
      heroku.set_workers(ENV["APP_NAME"], 0)
    end
  end    
end
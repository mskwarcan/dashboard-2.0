class Mailchimp < Struct.new(:user, :update, :heroku) 
  def perform
    begin
      @update = Update.first(:conditions => {:id => update.id})
    
      h = Hominid::API.new(user.mailchimp)
      
      list_id = h.lists.first.second.first["id"]
      @update.chimp_name = h.lists.first.second.first["name"]
      @update.growth = ActiveSupport::JSON.encode(h.list_growth_history(list_id))
      @update.campaign = ActiveSupport::JSON.encode(h.campaigns(filters ={:status => "sent"}, start= 0)["data"])
      @update.stats = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].first["id"]))
      @update.stats2 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].second["id"]))
      @update.stats3 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].third["id"]))
      @update.stats4 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].third["id"]))
      @update.stats5 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].third["id"]))
      @update.stats6 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].third["id"]))
      @update.stats7 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].third["id"]))
      @update.stats8 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].third["id"]))
      @update.stats9 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].third["id"]))
      @update.stats10 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns(filters ={:status => "sent"}, start= 0)["data"].third["id"]))
      @update.chatter = ActiveSupport::JSON.encode(h.chimp_chatter)
      click_rate = []
      open_rate = []
      
      campaigns = h.campaigns(filters ={:status => "sent"}, start= 0, limit = 100)["data"]
      
      campaigns.each do |campaign|
          opened = h.campaign_stats(campaign["id"])["unique_opens"]
          total = h.campaign_stats(campaign["id"])["emails_sent"]
          clicks = h.campaign_stats(campaign["id"])["users_who_clicked"]
          open = sprintf("%.2f", opened/total*100)
          click = sprintf("%.2f", clicks/total*100)
        
          open_rate << {:rate => open, :name => campaign["title"], :opened => opened}
          click_rate << {:rate => click, :name => campaign["title"], :clicks => clicks}
      end
      
      open_rate.sort! { |a,b| b[:rate] <=> a[:rate] }
      click_rate.sort! { |a,b| b[:rate] <=> a[:rate] }
      
      @update.top_open = ActiveSupport::JSON.encode(open_rate)
      @update.top_click = ActiveSupport::JSON.encode(click_rate)
      
      @update.chimp_done = true
    
      @update.save
      
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
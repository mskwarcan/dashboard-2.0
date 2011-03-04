class Mailchimp < Struct.new(:user, :update, :heroku) 
  def perform
    begin
      @update = Update.first(:conditions => {:id => update.id})
    
      h = Hominid::API.new(user.mailchimp)
      puts "Step 1"
      list_id = h.lists.first.second.first["id"]
      @update.chimp_name = h.lists.first.second.first["name"]
      @update.growth = ActiveSupport::JSON.encode(h.list_growth_history(list_id))
      @update.campaign = ActiveSupport::JSON.encode(h.campaigns["data"])
      puts "Step 2"
      @update.stats = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns["data"].first["id"]))
      @update.stats2 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns["data"].second["id"]))
      @update.stats3 = ActiveSupport::JSON.encode(h.campaign_stats(h.campaigns["data"].third["id"]))
      puts "Step 3"
      @update.chatter = ActiveSupport::JSON.encode(h.chimp_chatter)
      puts "Step 4"
      click_rate = []
      open_rate = []
      puts "Step 5"
      campaigns = h.campaigns(filters ={}, start= 0, limit = 100)["data"]
      puts "Step 6"
      campaigns.each do |campaign|
        opened = h.campaign_stats(campaign["id"])["unique_opens"]
        total = h.campaign_stats(campaign["id"])["emails_sent"]
        clicks = h.campaign_stats(campaign["id"])["users_who_clicked"]
        open = sprintf("%.2f", opened/total*100)
        click = sprintf("%.2f", clicks/total*100)
        
        open_rate << {:rate => open, :name => campaign["title"], :opened => opened}
        click_rate << {:rate => click, :name => campaign["title"], :clicks => clicks}
      end
      puts "Step 7"
      open_rate.sort! { |a,b| a[:rate] <=> b[:rate] }
      click_rate.sort! { |a,b| a[:rate] <=> b[:rate] }
      puts "Step 8"
      @update.top_open = ActiveSupport::JSON.encode(open_rate)
      @update.top_click = ActiveSupport::JSON.encode(click_rate)
      puts "Step 9"
      @update.chimp_done = true
    
      @update.save
      puts "Step 10"
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
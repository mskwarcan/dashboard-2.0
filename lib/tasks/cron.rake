desc "This task is called by the cron add-on"
task :cron => :environment do
  @accounts = Account.all
  
  @accounts.each do |account|
    
    @update = Update.new
    @update.account_id = account.id
    
    if account.twitter_token
      #Delayed::Job.enqueue Tweet.new(user, @update, heroku)
      account.twitter_init
      @update.twitter_user = ActiveSupport::JSON.encode(account.twitter_user) #profile_image_url, screen_name, followers_count
      @update.tweets = ActiveSupport::JSON.encode(Twitter.user_timeline)

      if Time.now.day == 1 && Time.now.hour < 3
        account.twitter_monthly_count = account.twitter_user["followers_count"]
        account.save
      end
      twitter_done = true
    else
      twitter_done = true
    end

    if account.facebook_profile_id
      #Delayed::Job.enqueue Facebook.new(user, @update, heroku)
      client = Account.facebook(account.facebook_token)
      
      page = client.object(account.facebook_profile_id)
      
      uri = URI.parse(URI.encode("https://api.facebook.com/method/fql.query?access_token=#{account.facebook_token}&query=SELECT impressions FROM stream WHERE source_id=#{account.facebook_profile_id} and actor_id=#{account.facebook_profile_id} LIMIT 10"))
      connection = Net::HTTP.new(uri.host, 443)
      connection.use_ssl = true
      
      impressions = Hash.from_xml(resp = connection.request_get(uri.path + '?' + uri.query).body)
      
      @update.facebook_info = ActiveSupport::JSON.encode(page) #name, likes
      posts = client.object_posts(account.facebook_profile_id, :access_token => account.facebook_token, :limit => 10)
      feed = []
      posts.each_with_index do |post,i|
        feed << [:name => post["from"]["name"], 
                 :picture => FGraph.object(post["from"]["id"])["picture"], 
                 :message => post["message"],
                 :photo_title => post["name"],
                 :photo => post["picture"],
                 :link => post["link"]
                 :description => post["description"],
                 :likes => post["likes"].nil? ? nil : post["likes"]["count"],
                 :comments => post["comments"].nil? ? nil : post["comments"]["data"],
                 :impressions => impressions["fql_query_response"]["stream_post"][i]["impressions"]
                 ]
      end 
      
      @update.facebook_posts = ActiveSupport::JSON.encode(feed)
      
      if Time.now.day == 1 && Time.now.hour < 3
        account.facebook_monthly_count = client.object(account.facebook_profile_id)["likes"]
        account.save
      end
      facebook_done = true
    else
      facebook_done = true
    end

    
    if account.google_profile_id
      #Delayed::Job.enqueue Google.new(user, @update, heroku)
      client = Account.google
      at = OAuth::AccessToken.new(client, account.google_token, account.google_secret)
      
      next_month = 1.month.from_now.strftime("%Y-%m-01")
      current_month = Time.now.strftime('%Y-%m-01')
    	last_month = 1.month.ago.strftime("%Y-%m-01")
    	two_months_ago = 2.month.ago.strftime("%Y-%m-01")
    	three_months_ago = 3.month.ago.strftime("%Y-%m-01")
      
      @update.current_analytics = account.get_analytics_data(at, current_month, next_month)
      @update.last_month_analytics = account.get_analytics_data(at, last_month, current_month)
      @update.two_months_ago_analytics = account.get_analytics_data(at, two_months_ago, last_month)
      @update.three_months_ago_analytics = account.get_analytics_data(at, three_months_ago, two_months_ago)
      google_done = true
    else
      google_done = true
    end
    
    if account.mailchimp_list_id
      #Delayed::Job.enqueue Mailchimp.new(user, @update, heroku)
      client = Hominid::API.new(account.mailchimp_api_key)
      
      @update.mailchimp_growth = ActiveSupport::JSON.encode(client.list_growth_history(account.mailchimp_list_id))
      campaigns = client.campaigns(filters ={:status => "sent"}, start= 0, limit = 100)["data"]
      
      campaign_stats = []
      click_rate = []
      open_rate = []
      
      campaigns.each do |campaign|
        stats = client.campaign_stats(campaign["id"])
        campaign_stats << [stats, campaign]
        
        opened = stats["unique_opens"]
        total = stats["emails_sent"]
        clicks = stats["users_who_clicked"]
        open = sprintf("%.2f", opened/total*100)
        click = sprintf("%.2f", clicks/total*100)
      
        open_rate << {:rate => open, :name => campaign["title"], :opened => opened}
        click_rate << {:rate => click, :name => campaign["title"], :clicks => clicks}
      end
      
      open_rate.sort! { |a,b| b[:rate] <=> a[:rate] }
      click_rate.sort! { |a,b| b[:rate] <=> a[:rate] }
      
      @update.mailchimp_open_rates = ActiveSupport::JSON.encode(open_rate)
      @update.mailchimp_click_rates = ActiveSupport::JSON.encode(click_rate)
      @update.mailchimp_chatter = ActiveSupport::JSON.encode(client.chimp_chatter)
      
      @update.mailchimp_campaigns = ActiveSupport::JSON.encode(campaign_stats)
      
      chimp_done = true
    else
      chimp_done = true
    end
    
    if(twitter_done == true && facebook_done == true && google_done == true && chimp_done == true)
      @update.save
    end
        
  end
  
  
end
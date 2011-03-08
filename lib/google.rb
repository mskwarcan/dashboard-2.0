class Google < Struct.new(:user, :update, :heroku) 
  def perform
    begin
      @update = Update.first(:conditions => {:id => update.id})
    
      gs = User.google
    
      gs.profile_id = user.analytics
      
      currentMonth = Time.now.strftime('%Y-%m-01')
    	lastMonth = 1.month.ago.strftime("%Y-%m-01")
    	monthTwo = 2.month.ago.strftime("%Y-%m-01")
    	monthThree = 3.month.ago.strftime("%Y-%m-01")
    	nextMonth = 1.month.from_now.strftime("%Y-%m-01")
    
      current = gs.get({:start_date => currentMonth, :end_date => nextMonth, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits', 'goalCompletionsAll', 'impressions','adClicks']})
      @update.results = ActiveSupport::JSON.encode(current.points.first.metrics)
      last = gs.get({:start_date => lastMonth, :end_date => currentMonth, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits', 'goalCompletionsAll', 'impressions','adClicks']})
      @update.last_month = ActiveSupport::JSON.encode(last.points.first.metrics)
      two_months = gs.get({:start_date => monthTwo, :end_date => lastMonth, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits', 'goalCompletionsAll', 'impressions','adClicks']})
      @update.two_months = ActiveSupport::JSON.encode(two_months.points.first.metrics)
      three_months = gs.get({:start_date => monthThree, :end_date => monthTwo, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits', 'goalCompletionsAll', 'impressions','adClicks']})
      @update.three_months = ActiveSupport::JSON.encode(three_months.points.first.metrics)
    
      @update.google_done = true
    
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

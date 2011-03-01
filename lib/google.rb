class Google < Struct.new(:user, :update, :heroku) 
  def perform
    begin
      @update = Update.first(:conditions => {:id => update.id})
    
      gs = User.google
    
      gs.profile_id = user.analytics
      
      currentMonth = Time.now.strftime('%Y-%m-01')
    	lastMonth = 1.month.ago.strftime("%Y-%m-01")
    	nextMonth = 1.month.from_now.strftime("%Y-%m-01")
    
      current = gs.get({:start_date => currentMonth, :end_date => nextMonth, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits']})
      @update.results = ActiveSupport::JSON.encode(current.points.first.metrics)
      last = gs.get({:start_date => lastMonth, :end_date => currentMonth, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits']})
      @update.last_month = ActiveSupport::JSON.encode(last.points.first.metrics)
    
      @update.save
    
    rescue
      return
    end
    
    if Delayed::Job.count == 1
      heroku.set_workers(ENV["APP_NAME"], 0)
    end
  end    
end

results = gs.get({ :start_date => '2011-01-01',:end_date => '2011-02-01',:metrics => 'pageviews')
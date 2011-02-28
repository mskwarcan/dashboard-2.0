class Google < Struct.new(:user, :update) 
  def perform
    @update = Update.first(:conditions => {:id => update.id})
    
    gs = User.google
    
    gs.profile_id = user.analytics
    
    currentMonth = Time.now.strftime('%Y-%m-01')
  	lastMonth = 1.month.ago.strftime("%Y-%m-01")
  	twoMonths = 2.month.ago.strftime("%Y-%m-01")
    
    current = gs.get({:start_date => lastMonth, :end_date => currentMonth, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits']})
    @update.results = ActiveSupport::JSON.encode(current.points.first.metrics)
    last = gs.get({:start_date => twoMonths, :end_date => lastMonth, :metrics => ['pageviews','avgTimeOnSite','newVisits','visits']})
    @update.last_month = ActiveSupport::JSON.encode(last.points.first.metrics)
    
    @update.save
    
    if Delayed::Job.count == 0
      heroku.set_workers(ENV["APP_NAME"], 0)
    end
  end    
end

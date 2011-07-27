class Updates < ActiveRecord::Migration
  def self.up
    create_table :updates do |t|
      t.text :twitter_user
      t.text :tweets
      
      t.text :facebook_posts
      t.text :facebook_info
      t.string :facebook_picture
      
      t.text :current_analytics
      t.text :last_month_analytics
      t.text :two_months_ago_analytics
      t.text :three_months_ago_analytics
      
      t.text :mailchimp_growth
      t.text :mailchimp_chatter
      t.text :mailchimp_campaigns
      t.text :mailchimp_open_rates
      t.text :mailchimp_click_rates
      t.text :mailchimp_chatter

      t.timestamps
    end
  end

  def self.down
    drop_table :updates
  end
end

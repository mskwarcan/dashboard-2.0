class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :facebook_token
      t.string :twitter_token
      t.string :twitter_secret
      t.integer :twitter_monthly_count
      t.integer :facebook_monthly_count
      t.string :mailchimp_api_key
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end

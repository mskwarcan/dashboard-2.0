class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :client
      t.string :password
      t.string :twitter_token
      t.string :twitter_secret
      t.string :linkedin_token
      t.string :linkedin_secret
      t.string :facebook_token
      t.boolean :fb_authenticated, :default => false
      t.boolean :twitter_authenticated, :default => false
      t.boolean :linkedin_authenticated, :default => false
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

class UserFields < ActiveRecord::Migration
  def self.up
    remove_column :users, :linkedin_token
    remove_column :users, :linkedin_secret
    remove_column :users, :linkedin_authenticated
    add_column :users, :twitter_monthly_count, :integer
  end

  def self.down
    add_column :users, :linkedin_token, :string
    add_column :users, :linkedin_secret, :string
    add_column :users, :linkedin_authenticated, :string
    remove_column :users, :twitter_monthly_count
  end
end

class GoogleAnaltics < ActiveRecord::Migration
  def self.up
    add_column :accounts, :google_token, :string
    add_column :accounts, :google_secret, :string
  end

  def self.down
    remove_column :accounts, :google_token
    remove_column :accounts, :google_secret
  end
end

class Youtube < ActiveRecord::Migration
  def self.up
    add_column :accounts, :youtube_token, :string
    add_column :accounts, :youtube_secret, :string
  end

  def self.down
    remove_column :accounts, :youtube_token, :string
    remove_column :accounts, :youtube_secret, :string
  end
end

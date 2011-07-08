class FacebookProfileId < ActiveRecord::Migration
  def self.up
    add_column :accounts, :facebook_profile_id, :string
  end

  def self.down
    remove_column :accounts, :facebook_profile_id
  end
end

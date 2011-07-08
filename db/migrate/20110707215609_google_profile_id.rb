class GoogleProfileId < ActiveRecord::Migration
  def self.up
    add_column :accounts, :google_profile_id, :string
  end

  def self.down
    remove_column :accounts, :google_profile_id
  end
end

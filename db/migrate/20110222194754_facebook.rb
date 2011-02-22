class Facebook < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_monthly_count, :integer
  end

  def self.down
    remove_column :users, :facebook_monthly_count
  end
end

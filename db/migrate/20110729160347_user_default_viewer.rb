class UserDefaultViewer < ActiveRecord::Migration
  def self.up
    change_column :users, :type_of_user, :string, :default => "viewer"
  end

  def self.down
  end
end

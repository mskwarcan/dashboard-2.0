class UserIdSwitch < ActiveRecord::Migration
  def self.up
    remove_column :updates, :user_id
    add_column :updates, :user_id, :integer
  end

  def self.down
    remove_column :updates, :user_id
    add_column :updates, :user_id, :string
  end
end

class RemoveTypeFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :type
    add_column :users, :type_of_user, :string
  end

  def self.down
    add_column :users, :type, :string
    remove_column :users, :type_of_user
  end
end

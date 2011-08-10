class RemoveFbPic < ActiveRecord::Migration
  def self.up
    remove_column :updates, :facebook_picture
  end

  def self.down
    add_column :updates, :facebook_picture, :string
  end
end

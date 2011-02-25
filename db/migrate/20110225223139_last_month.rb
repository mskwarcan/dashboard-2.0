class LastMonth < ActiveRecord::Migration
  def self.up
    add_column :updates, :last_month, :text
  end

  def self.down
    remove_column :updates, :last_month
  end
end

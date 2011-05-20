class Adwords < ActiveRecord::Migration
  def self.up
    add_column :updates, :adwords, :text
    add_column :updates, :last_adwords, :text
    add_column :updates, :two_months_adwords, :text
    add_column :updates, :three_months_adwords, :text
  end

  def self.down
    remove_column :updates, :adwords
    remove_column :updates, :last_adwords
    remove_column :updates, :two_months_adwords
    remove_column :updates, :three_months_adwords
  end
end

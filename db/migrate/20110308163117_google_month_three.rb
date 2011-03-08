class GoogleMonthThree < ActiveRecord::Migration
  def self.up
    add_column :updates, :three_months, :text
  end

  def self.down
    remove_column :updates, :three_months
  end
end

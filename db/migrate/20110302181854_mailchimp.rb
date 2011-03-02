class Mailchimp < ActiveRecord::Migration
  def self.up
    add_column :users, :mailchimp, :string
    add_column :users, :mailchimp_authenticated, :boolean, :default => false
    add_column :updates, :two_months, :text
  end

  def self.down
    remove_column :users, :mailchimp_authenticated
    remove_column :users, :mailchimp
    remove_column :updates, :two_months
  end
end

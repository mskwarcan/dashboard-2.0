class Mailchimp < ActiveRecord::Migration
  def self.up
    add_column :accounts, :mailchimp_list_id, :string
  end

  def self.down
    remove_column :accounts, :mailchimp_list_id
  end
end

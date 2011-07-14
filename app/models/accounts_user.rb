class AccountsUser < ActiveRecord::Base
  belongs_to :account
  belongs_to :user
  
  validates_uniqueness_of :account_id, :scope => [:user_id]
  
  def self.admin(user_id, account_id, status = 'pending')
    relation = AccountsUser.first(:conditions => {:user_id => user_id, :account_id => account_id})
    relation.access = 'admin'
    relation.status = status
    relation.save
  end
  
  def self.viewer(user_id, account_id, status = 'pending')
    relation = AccountsUser.first(:conditions => {:user_id => user_id, :account_id => account_id})
    relation.access = 'viewer'
    relation.status = status
    relation.save
  end
end
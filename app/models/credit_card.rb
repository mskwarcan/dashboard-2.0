class CreditCard < Tableless
  
  column :first_name, :string
  column :last_name, :string  
  column :number, :integer  
  column :ccv, :integer  
  column :month, :string  
  column :year, :string  
  column :card_type, :string  
  
  validates_presence_of :first_name, :last_name, :number, :ccv
  
end
module RubyPsigate
  class Account
    
    attr_accessor :account_id
    attr_accessor :name, :company
    attr_accessor :address1, :address2, :city, :province, :postal_code
    
    alias_method :state, :province
    alias_method :state=, :province=
    alias_method :zipcode, :postal_code
    alias_method :zipcode=, :postal_code=
    
  end
end
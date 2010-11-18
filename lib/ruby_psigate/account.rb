module RubyPsigate
  class Account
    
    attr_accessor :account_id
    attr_accessor :name, :company, :email, :comments
    attr_accessor :address1, :address2, :city, :province, :postal_code, :country, :phone, :fax
    
    alias_method :state, :province
    alias_method :state=, :province=
    alias_method :zipcode, :postal_code
    alias_method :zipcode=, :postal_code=
    
    def initialize(attributes={})
      # @account_id = attributes[:account_id]
      # @name       = attributes[:name]
      # @company    = attributes[:company]
      # @email      = attributes[:email]
      # @comments   = attributes[:comments]
      # @address1   
      
      attributes.each_pair do |attribute, value|
        if self.respond_to?(attribute)
          setter = "#{attribute}=".to_sym
          self.send(setter, value)
        end
      end
    end
    
    def credit_card=(cc_object)
      raise ArgumentError unless cc_object.is_a?(PgCreditcard)
      @credit_card = cc_object
    end
    
  end
end
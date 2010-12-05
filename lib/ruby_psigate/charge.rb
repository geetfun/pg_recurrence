module RubyPsigate
  class Charge < Request
    
    attr_accessor :accountid, :productid, :quantity, :price, :response
    
    def self.serialno
      @serialno
    end
    
    def self.serialno=(x)
      @serialno=x
    end
    
    def initialize(attributes={})
      attributes.each_pair do |attribute, value|
        if self.respond_to?(attribute)
          setter = "#{attribute}=".to_sym
          self.send(setter, value)
        end
      end
      super
    end
    
    def immediately
      raise ArgumentError, "StoreID is not specified in superclass" if self.class.storeid.nil?
      begin
        @request[:Request][:Action] = "RBC99"
        @request[:Request][:Charge] = {
          :StoreID => self.class.storeid,
          :SerialNo => self.class.serialno,
          :AccountID => accountid,
          :ItemInfo => {
            :ProductID => productid,
            :Quantity => quantity,
            :Price => price
          }
        }
        
        # Creates parameters
        params = RubyPsigate::Serializer.new(@request, :header => true).to_xml        
        connection = RubyPsigate::Connection.new(self.class.credential.endpoint)
        response = connection.post(params)        
        response = Response.new(response)
        self.response = response
        
        if response.success? && response.returncode == "PSI-0000" 
          result = true
        else
          result = false
        end
      rescue ConnectionError => e
        result = false
      end
      result
    end
    
  end
end
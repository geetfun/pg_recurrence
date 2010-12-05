module RubyPsigate
  class Charge < Request
    
    def immediately
      begin
        # charge = Charge.new(:accountid => @account.accountid, :productid => "123456", :quantity => "1", :price => "10")
        
      rescue ConnectionError => e
        response = false
      end
      response
    end
    
  end
end
require 'helper'

module RubyPsigate
  class TestChargeRemote < Test::Unit::TestCase
    
    def setup
      @account = create_account
    end
    
    def test_add_charge
      
    end
    
    def test_update_charge
      
    end
    
    def test_delete_charge
      
    end
    
    def test_retrieve_charge
      
    end
    
    def test_enable_charge
      
    end
    
    def test_disable_charge
      
    end
    
    def test_immediate_charge
      charge = Charge.new(:accountid => @account.accountid, :productid => "123456", :quantity => "1", :price => "10")
      assert charge.immediately
    end
    
  end
end
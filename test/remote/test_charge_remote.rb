require 'helper'

module RubyPsigate
  class TestChargeRemote < Test::Unit::TestCase
    
    def setup
      Request.credential = credential
      Request.storeid = "teststore"
      Charge.serialno = "1"
      @account = create_account
    end
        
    def test_add_charge
      @charge = Charge.new(:accountid => @account.accountid, :interval => "M", :rbtrigger => "15", :starttime => "2010.12.25", :endtime => "2011.12.25", :productid => "123456789", :quantity => "1", :price => "99.00")
      assert @charge.save
      
      # Example of return response
      # RuntimeError: #<RubyPsigate::Response:0x00000102858ee8 @xml_response={"Response"=>{"CID"=>"1000001", "Action"=>"REGISTER NEW CHARGE(S)", "ReturnCode"=>"RRC-0000", "ReturnMessage"=>"Register Recurring Charges completed successfully.", "Charge"=>{"ReturnCode"=>"RRC-0050", "ReturnMessage"=>"Register Recurring Charge completed successfully.", "RBCID"=>"2010120512535613602", "StoreID"=>"teststore", "RBName"=>nil, "AccountID"=>"2010120518622", "SerialNo"=>"1", "Status"=>"A", "Interval"=>"M", "Trigger"=>"15", "ProcessType"=>"A", "InstallmentNo"=>"0", "StartDate"=>"2010.12.25", "EndDate"=>"2011.12.25", "ItemInfo"=>{"Status"=>"A", "ItemSerialNo"=>"1", "ProductID"=>"123456789", "Description"=>nil, "Quantity"=>"1.00", "Price"=>"99.00", "Tax1"=>"0.00", "Tax2"=>"0.00", "Cost"=>"0.00", "SubTotal"=>"99.00"}}}}>
    end
    
    def test_find_charge
      
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
    
    def test_response
      charge = Charge.new(:accountid => @account.accountid, :productid => "123456", :quantity => "1", :price => "10")
      charge.immediately
      response = charge.response
      assert response.is_a?(RubyPsigate::Response)
      
      # Example of return response
      #RuntimeError: #<RubyPsigate::Response:0x00000101455130 @xml_response={"Response"=>{"CID"=>"1000001", "Action"=>"REGISTER AN IMMEDIATE CHARGE", "ReturnCode"=>"PSI-0000", "ReturnMessage"=>"The transaction completed successfully.", "Invoice"=>{"StoreID"=>"teststore", "PayerName"=>"Homer Simpsons", "Status"=>"Paid", "InvoiceNo"=>"030705", "ReturnCode"=>"Y:123456:0abcdef:M:X:NNN", "ErrMsg"=>nil, "InvoiceDate"=>"2010.12.05", "ExecDate"=>"2010.12.05", "RBCID"=>"2010120511081813577", "AccountID"=>"2010120518355", "SerialNo"=>"1", "CardNumber"=>"411111...1111", "CardExpMonth"=>"03", "CardExpYear"=>"20", "CardType"=>"VISA", "InvoiceTotal"=>"10.00", "ItemInfo"=>{"ItemSerialNo"=>"1", "ProductID"=>"123456", "Description"=>nil, "Quantity"=>"1.00", "Price"=>"10.00", "Tax1"=>"0.00", "Tax2"=>"0.00", "Cost"=>"0.00", "SubTotal"=>"10.00"}}}}>
    end
    
  end
end
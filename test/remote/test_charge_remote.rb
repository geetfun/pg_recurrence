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
    
    def test_assigns_rbcid_after_save
      @charge = Charge.new(:accountid => @account.accountid, :interval => "M", :rbtrigger => "15", :starttime => "2010.12.25", :endtime => "2011.12.25", :productid => "123456789", :quantity => "1", :price => "99.00")
      @charge.save
      assert_not_nil @charge.rbcid
    end
    
    def test_find_charge
      @test_charge = Charge.new(:accountid => @account.accountid, :interval => "M", :rbtrigger => "15", :starttime => "2010.12.25", :endtime => "2011.12.25", :productid => "123456789", :quantity => "1", :price => "99.00")
      @test_charge.save
      
      @charge = Charge.find(@test_charge.rbcid)
      assert_not_nil @charge
      
      # Example of return response
      # RuntimeError: #<RubyPsigate::Response:0x00000101218188 @xml_response={"Response"=>{"CID"=>"1000001", "Action"=>"RETRIEVE A SUMMARY OF CHARGES", "ReturnCode"=>"RRC-0060", "ReturnMessage"=>"Retrive Recurring Charges Information completed successfully.", "Condition"=>{"RBCID"=>"2010120514303113630"}, "Charge"=>{"RBCID"=>"2010120514303113630", "StoreID"=>"teststore", "RBName"=>nil, "AccountID"=>"2010120518769", "SerialNo"=>"1", "Status"=>"A", "Interval"=>"M", "Trigger"=>"15", "ProcessType"=>"A", "InstallmentNo"=>"1", "StartDate"=>"2010.12.25", "EndDate"=>"2011.12.25"}}}>
    end
    
    # Psigate only allows the changing of certain charge elements
    # SerialNo (payment method)
    # Interval
    # RbTrigger
    # Starttime
    # Endtime
    def test_update_charge
      @test_charge = Charge.new(:accountid => @account.accountid, :interval => "M", :rbtrigger => "15", :starttime => "2010.12.25", :endtime => "2011.12.25", :productid => "123456789", :quantity => "1", :price => "99.00")
      @test_charge.save
      
      assert = Charge.update(
        :rbcid => @test_charge.rbcid,
        :rbname => "New Name",
        :serialno => "2",
        :interval => "A",
        :RBTrigger => "10",
        :StartTime => "2010.12.30",
        :EndTime => "2011.12.30"
      )
      
      # Example of return response
      # RuntimeError: #<RubyPsigate::Response:0x00000100944098 @xml_response={"Response"=>{"CID"=>"1000001", "Action"=>"UPDATE A CHARGE", "ReturnCode"=>"RRC-0072", "ReturnMessage"=>"Update Recurring Charge Information completed successfully.", "Condition"=>{"RBCID"=>"2010120522260613649"}, "Update"=>{"Interval"=>"A", "SerialNo"=>"2", "RBName"=>"New Name"}}}>
    end
    
    def test_enable_charge
      @test_charge = Charge.new(:accountid => @account.accountid, :interval => "M", :rbtrigger => "15", :starttime => "2010.12.25", :endtime => "2011.12.25", :productid => "123456789", :quantity => "1", :price => "99.00")
      @test_charge.save
      
      assert Charge.enable(@test_charge.rbcid)      
    end
    
    def test_disable_charge
      @test_charge = Charge.new(:accountid => @account.accountid, :interval => "M", :rbtrigger => "15", :starttime => "2010.12.25", :endtime => "2011.12.25", :productid => "123456789", :quantity => "1", :price => "99.00")
      @test_charge.save
      
      assert Charge.disable(@test_charge.rbcid)
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
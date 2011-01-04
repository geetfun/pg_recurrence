require 'helper'

module RubyPsigate
  class TestAccountRemote < Test::Unit::TestCase
    
    def setup
      Request.credential = credential
      @comparison = create_account
    end
        
    def test_add_account
      @account = Account.new(valid_account_attributes)
      @account.save
    end
    
    def test_saving_account_assigns_accountid
      @account = Account.new(valid_account_attributes)
      assert_nil @account.accountid
      @account.save
      assert_not_nil @account.accountid
    end
  
    def test_returns_false_to_new_record_after_save
      @account = Account.new(valid_account_attributes)
      assert @account.new_record?
      @account.save
      @account = Account.find(@account.accountid)
      assert !@account.new_record?
    end
    
    def test_failure_adding_account
      @account = Account.new(:accountid => @comparison.accountid)
      assert !@account.save
      assert_not_nil @account.error
    end

    def test_find_account
      accountid = @comparison.accountid
      @account = Account.find(accountid)
      assert_equal @comparison.accountid, @account.accountid
    end
        
    def test_cannot_find_account
      accountid = "somefakeaccountid"
      @account = Account.find(accountid)
      assert_nil @account
    end
    
    def test_disables_account
      assert Account.disable(@comparison.accountid)
      
      # Tests
      @account = Account.find(@comparison.accountid)
      assert_equal "N", @account.status
    end
    
    def test_enable_account
      Account.disable(@comparison.accountid)
      assert Account.enable(@comparison.accountid)
      
      # Tests
      @account = Account.find(@comparison.accountid)
      assert_equal "A", @account.status
    end
    
    def test_update_attributes
      @account = @comparison
      assert @account.attributes = {
        :name => "Marge Simpson",
        :company => "NBC Corp",
        :address1 => "577 Street",
        :address2 => "Apt 888",
        :city => "Ottawa",
        :province => "ON",
        :country => "Canada",
        :postalcode => "A1A1A1",
        :phone => "1234567890",
        :fax => "1234567890",
        :email => "marge@nbc.com",
        :comments => "Some comment"  
      }
    end
    
    def test_update_record
      @account = Account.find(@comparison.accountid)
      @account.attributes = {
        :name => "Marge Simpson",
        :company => "NBC Corp",
        :address1 => "577 Street",
        :address2 => "Apt 888",
        :city => "Ottawa",
        :province => "ON",
        :country => "Canada",
        :postalcode => "A1A1A1",
        :phone => "1234567890",
        :fax => "1234567890",
        :email => "marge@nbc.com",
        :comments => "Some comment"
      }
      assert @account.save
    end
    
    def test_has_method_called_add_payment_method_after_find
      @account = Account.find(@comparison.accountid)
      assert @account.respond_to?(:add_payment_method)
    end
    
    def test_add_payment_method
      @account = @comparison
      @serial_no = @account.add_payment_method(credit_card)
      assert_not_nil @serial_no
    end
    
    def test_remove_payment_method
      @account = @comparison
    end
    
  end
end
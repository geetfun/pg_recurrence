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
    
    def test_return_true_for_new_record?
      @account = Account.new
      assert @account.new_record?
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
      @account = @comparison
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
    # 
    # # Update account
    # 
    # def test_successfully_updating_account
    #   temporary_account = create_deletable_account
    #   account_id = temporary_account.accountid
    #   # @account = Account.update(account_id, 
    #   #   :name => "Marge Simpson",
    #   #   :company => "NBC Corp",
    #   #   :address1 => "577 Street",
    #   #   :address2 => "Apt 888",
    #   #   :city => "Ottawa",
    #   #   :province => "ON",
    #   #   :country => "Canada",
    #   #   :postalcode => "A1A1A1",
    #   #   :phone => "1234567890",
    #   #   :fax => "1234567890",
    #   #   :email => "marge@nbc.com",
    #   #   :comments => "Some comment"
    #   # )
    #   Account.credential = credentials
    #   @account = Account.find(account_id)
    #   @account.name = "Marge Simpson"
    #   assert @account.update
    #   
    #   @account = Account.find(account_id)
    #   assert_equal "Marge Simpson", @account.name
    # end
    # 
    # def test_failure_in_updating_account
    #   
    # end
    
    
  end
end
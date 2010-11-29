require 'helper'

module RubyPsigate
  class TestAccountRemote < Test::Unit::TestCase
        
    # Add new account
    def test_add_account
      Request.credential = credential
      @account = Account.new(
        :name => "Homer Simpson",
        :email => "homer@simpsons.com",
        :address1 => "1234 Evergrove Drive",
        :address2 => nil,
        :city => "Toronto",
        :province => "ON",
        :postal_code => "M2N3A3",
        :country => "CA",
        :phone => "416-111-1111",
        :credit_card => credit_card,
      )
      @account.save
    end
    
    def test_saving_account_returns_account_instance
      
    end

    # def test_successfully_in_adding_account
    #   @credential = credentials
    #   @credit_card = credit_card
    # 
      # @account = Account.new(
      #   :name => "Homer Simpson",
      #   :email => "homer@simpsons.com",
      #   :address1 => "1234 Evergrove Drive",
      #   :address2 => nil,
      #   :city => "Toronto",
      #   :province => "ON",
      #   :postal_code => "M2N3A3",
      #   :country => "CA",
      #   :phone => "416-111-1111",
      #   :credit_card => @credit_card,
      #   :credentials => @credential
      # )
    # 
    #   result = @account.register
    #   assert result
    # end
    # 
    # def test_failure_in_adding_account
    #   @credential = credentials
    #   @credit_card = credit_card
    # 
    #   @account = Account.new(
    #     :name => "Home Simpson",
    #     :email => "homer@simpsons.com",
    #     :address1 => "1234 Evergrove Drive",
    #     :address2 => nil,
    #     :city => "Toronto",
    #     :province => "ON",
    #     :postal_code => "M2N3A3",
    #     :country => "CA",
    #     :phone => "416-111-1111",
    #     :credit_card => @credit_card,
    #     :credential => @credential
    #   )
    #   connection = mock()
    #   connection.expects(:post).raises(RubyPsigate::ConnectionError)
    #   RubyPsigate::Connection.expects(:new).returns(connection)
    #   result = @account.register
    #   assert !result
    # end
    # 
    # # Finding an existing account
    # 
    # def test_finding_an_account_with_account_id
    #   @credential = credentials
    #   Account.credential = @credential
    #   
    #   account_id = "000000000000000911" # This is a known account ID on Psigate's test server
    #   @account = Account.find(account_id)
    #   assert @account, "Did not find account when it should be found"
    # end
    # 
    # def test_failure_in_finding_account
    #   @credential = credentials
    #   Account.credential = @credential
    #   
    #   @account = Account.find("fake_account_id")
    #   assert !@account
    # end
    # 
    # def test_find_returns_account_instance
    #   @credential = credentials
    #   Account.credential = @credential
    #   
    #   account_id = "000000000000000911" # This is a known account ID on Psigate's test server
    #   @account = Account.find(account_id)
    #   assert_equal Account, @account.class
    # end
    # 
    # # Delete account
    # 
    # def test_successfully_deleting_account
    #   temporary_account = create_deletable_account
    #   account_id = temporary_account.accountid
    #   Account.credential = credentials
    #   @account = Account.destroy(account_id)
    #   assert_nil @account
    # end
    # 
    # def test_failure_in_deleting_account
    #   temporary_account = create_deletable_account
    #   account_id = temporary_account.accountid
    #   Account.credential = credentials
    #   
    #   connection = mock()
    #   connection.expects(:post).raises(RubyPsigate::ConnectionError)
    #   RubyPsigate::Connection.expects(:new).returns(connection)
    #   
    #   assert !Account.destroy(account_id)
    # end
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
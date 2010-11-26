require 'helper'

module RubyPsigate
  class TestAccountRemote < Test::Unit::TestCase
    
    # Helpers
    def credentials
      @credential = Credential.new(
        :CID => "1000001", :UserID => "teststore", :password => "testpass"
      )
    end
    
    def credit_card
      @credit_card = PgCreditcard.new(
        :name => "Homer Simpsons",
        :number => "4111111111111111",
        :month  => "03",
        :year   => "20",
        :cvv    => "123"
      )
    end
    
    def create_deletable_account
      @credential = credentials
      @credit_card = credit_card

      @account = Account.new(
        :name => "Home Simpson",
        :email => "homer@simpsons.com",
        :address1 => "1234 Evergrove Drive",
        :address2 => nil,
        :city => "Toronto",
        :province => "ON",
        :postal_code => "M2N3A3",
        :country => "CA",
        :phone => "416-111-1111",
        :credit_card => @credit_card,
        :credential => @credential
      )

      result = @account.register
      result
    end
    
    # Add new account

    def test_successfully_in_adding_account
      @credential = credentials
      @credit_card = credit_card

      @account = Account.new(
        :name => "Home Simpson",
        :email => "homer@simpsons.com",
        :address1 => "1234 Evergrove Drive",
        :address2 => nil,
        :city => "Toronto",
        :province => "ON",
        :postal_code => "M2N3A3",
        :country => "CA",
        :phone => "416-111-1111",
        :credit_card => @credit_card,
        :credential => @credential
      )

      result = @account.register
      assert result
    end

    def test_failure_in_adding_account
      @credential = credentials
      @credit_card = credit_card

      @account = Account.new(
        :name => "Home Simpson",
        :email => "homer@simpsons.com",
        :address1 => "1234 Evergrove Drive",
        :address2 => nil,
        :city => "Toronto",
        :province => "ON",
        :postal_code => "M2N3A3",
        :country => "CA",
        :phone => "416-111-1111",
        :credit_card => @credit_card,
        :credential => @credential
      )
      connection = mock()
      connection.expects(:post).raises(RubyPsigate::ConnectionError)
      RubyPsigate::Connection.expects(:new).returns(connection)
      result = @account.register
      assert !result
    end
    
    # Finding an existing account
    
    def test_finding_an_account_with_account_id
      @credential = credentials
      Account.credential = @credential
      
      account_id = "000000000000000911" # This is a known account ID on Psigate's test server
      @account = Account.find(account_id)
      assert @account, "Did not find account when it should be found"
    end
    
    def test_failure_in_finding_account
      @credential = credentials
      Account.credential = @credential
      
      @account = Account.find("fake_account_id")
      assert !@account
    end

    # Delete account

    def test_successfully_deleting_account
      temporary_account = create_deletable_account
      account_id = temporary_account.accountid
      Account.credential = credentials
      @account = Account.destroy(account_id)
      assert_nil @account
    end

    def test_failure_in_deleting_account
      temporary_account = create_deletable_account
      account_id = temporary_account.accountid
      Account.credential = credentials
      
      connection = mock()
      connection.expects(:post).raises(RubyPsigate::ConnectionError)
      RubyPsigate::Connection.expects(:new).returns(connection)
      
      @account = Account.destroy(account_id)
      assert_not_nil @account
    end

    # Update account

    def test_successfully_updating_account

      response = @account.update
    end

    def test_failure_in_updating_account

    end
    
    
  end
end
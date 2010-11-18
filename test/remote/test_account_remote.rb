require 'helper'

module RubyPsigate
  class TestAccountRemote < Test::Unit::TestCase
    
    # Add new account

    def test_successfully_in_adding_account
      @creditcard = PgCreditcard.new(
        :name => "Homer Simpsons",
        :number => "4111111111111111",
        :month  => "03",
        :year   => "20",
        :cvv    => "123"
      )

      @account = Account.new(
        # Put in info here
      )

      result = @account.register
      assert result.success?
    end

    def test_failure_in_adding_account
      #
      #
      
      result = @account.register
      assert !result.success?
    end
    
    # Finding an existing account
    
    def test_finding_an_account_with_account_id
      account_id = nil
      @account = Account.find(account_id)
      assert @account
    end

    # Delete account

    def test_successfully_deleting_account


      response = @account.delete
      assert response.success?
    end

    def test_failure_in_deleting_account


      response = @account.delete
      assert !response.success?
    end

    # Update account

    def test_successfully_updating_account

      response = @account.update
    end

    def test_failure_in_updating_account

    end
    
    
  end
end
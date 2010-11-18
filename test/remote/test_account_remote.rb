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

      )

    end

    def test_failure_in_adding_account

    end

    # Delete account

    def test_successfully_deleting_account

    end

    def test_failure_in_deleting_account

    end

    # Update account

    def test_successfully_updating_account

    end

    def test_failure_in_updating_account

    end
    
    
  end
end
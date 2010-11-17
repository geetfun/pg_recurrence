require 'helper'

module RubyPsigate
  class TestAccount < Test::Unit::TestCase
    
    def test_account_id_setter
      @account = Account.new
      assert @account.respond_to?(:account_id=), "Account instance does not have account_id setter"
    end
  
    def test_account_id_getter
      @account = Account.new
      assert @account.respond_to?(:account_id), "Account instance does not have account_id getter"
    end

    def test_name_setter
      @account = Account.new
      assert @account.respond_to?(:name=), "Account instance does not have name setter"      
    end

    def test_name_getter
      @account = Account.new
      assert @account.respond_to?(:name), "Account instance does not have name getter"
    end
    
  end
end
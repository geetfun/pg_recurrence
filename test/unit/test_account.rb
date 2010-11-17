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
    
    def test_company_setter
      @account = Account.new
      assert @account.respond_to?(:company=), "Account instance does not have company setter"
    end
    
    def test_company_getter
      @account = Account.new
      assert @account.respond_to?(:company), "Account instance does not have company getter"
    end
    
    def test_address1_setter
      @account = Account.new
      assert @account.respond_to?(:address1=), "Account instance does not have address1 setter"
    end
    
    def test_address1_getter
      @account = Account.new
      assert @account.respond_to?(:address1), "Account instance does not have address1 getter"
    end

    def test_address2_setter
      @account = Account.new
      assert @account.respond_to?(:address2=), "Account instance does not have address2 setter"
    end
    
    def test_address2_getter
      @account = Account.new
      assert @account.respond_to?(:address2), "Account instance does not have address2 getter"
    end

    def test_city_setter
      @account = Account.new
      assert @account.respond_to?(:city=), "Account instance does not have city setter"
    end
    
    def test_city_getter
      @account = Account.new
      assert @account.respond_to?(:city), "Account instance does not have city getter"
    end

    def test_province_setter
      @account = Account.new
      assert @account.respond_to?(:province=), "Account instance does not have province setter"
    end
    
    def test_province_getter
      @account = Account.new
      assert @account.respond_to?(:province), "Account instance does not have province getter"
    end
    
    def test_state_setter_is_same_as_province_setter
      @account = Account.new
      @account.state = "Something"
      assert_equal @account.province, @account.state
    end
    
    def test_state_getter_is_same_as_province_getter
      @account = Account.new
      @account.province = "Something"
      assert_equal @account.state, @account.province
    end
    
    def test_postal_code_setter
      @account = Account.new
      assert @account.respond_to?(:postal_code=), "Account instance does not have postal code setter"
    end

    def test_postal_code_getter
      @account = Account.new
      assert @account.respond_to?(:postal_code), "Account instance does not have province getter"
    end

    def test_zipcode_setter_is_same_as_postal_code_setter
      @account = Account.new
      @account.zipcode = "Something"
      assert_equal @account.postal_code, @account.zipcode
    end
    
    def test_zipcode_getter_is_same_as_postal_code_getter
      @account = Account.new
      @account.postal_code = "Something"
      assert_equal @account.zipcode, @account.postal_code
    end
    
    # country, phone, fax, email, comments, cardholder, number, expiry month, expiry year
    
    # Add new account
    
    def test_successfully_in_adding_account
      
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
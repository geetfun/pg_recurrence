require 'helper'

module RubyPsigate
  class TestAccount < Test::Unit::TestCase
    
    def setup
      Request.credential = credential
    end
    
    #####
    
    def test_account_id_setter
      @account = Account.new
      assert @account.respond_to?(:accountid=), "Account instance does not have accountid setter"
    end
  
    def test_account_id_getter
      @account = Account.new
      assert @account.respond_to?(:accountid), "Account instance does not have accountid getter"
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
      assert @account.respond_to?(:postalcode=), "Account instance does not have postal code setter"
    end

    def test_postal_code_getter
      @account = Account.new
      assert @account.respond_to?(:postalcode), "Account instance does not have postal code getter"
    end

    def test_country_setter
      @account = Account.new
      assert @account.respond_to?(:country=), "Account instance does not have country setter"
    end

    def test_country_getter
      @account = Account.new
      assert @account.respond_to?(:country), "Account instance does not have country getter"
    end

    def test_phone_setter
      @account = Account.new
      assert @account.respond_to?(:phone=), "Account instance does not have phone setter"
    end

    def test_phone_getter
      @account = Account.new
      assert @account.respond_to?(:phone), "Account instance does not have phone getter"
    end
    
    def test_fax_setter
      @account = Account.new
      assert @account.respond_to?(:fax=), "Account instance does not have fax setter"
    end

    def test_fax_getter
      @account = Account.new
      assert @account.respond_to?(:fax), "Account instance does not have fax getter"
    end

    def test_email_setter
      @account = Account.new
      assert @account.respond_to?(:email=), "Account instance does not have email setter"
    end

    def test_email_getter
      @account = Account.new
      assert @account.respond_to?(:email), "Account instance does not have email getter"
    end

    def test_comments_setter
      @account = Account.new
      assert @account.respond_to?(:comments=), "Account instance does not have comments setter"
    end

    def test_comments_getter
      @account = Account.new
      assert @account.respond_to?(:comments), "Account instance does not have comments getter"
    end
    
    # Holder for credit card object
    
    def test_credit_card_object_holder
      @account = Account.new
      assert @account.respond_to?(:credit_card=), "Account instance does not have credit card object setter"
    end
    
    def test_raises_error_if_credit_card_is_not_instance_of_pg_creditcard
      @account = Account.new
      assert_raise(ArgumentError) do
        @account.credit_card = "hello world"
      end
    end
    
    def test_raises_no_error_if_credit_card_is_instance_of_pg_creditcard
      creditcard = PgCreditcard.new(
        :name => "Homer Simpsons",
        :number => "4111111111111111",
        :month  => "03",
        :year   => "20",
        :cvv    => "123"
      )
      
      @account = Account.new
      assert_nothing_raised do
        @account.credit_card = creditcard
      end
    end
        
    # Creating instances from hash
    
    def test_new_account_instance_accepts_hash_of_values
      @account = Account.new(
        :accountid => "account_id_123",
        :name => "Homer Simpson"
      )
      
      assert @account, "Account instance not initialized from hash of attributes"
    end
    
    def test_new_account_instance_with_hash_will_assign_instance_variables
      attributes = {
        :accountid => "account_id_123",
        :name => "Homer Simpson",
        :country => "USA",
        :zipcode => "12345",
        :province => "Ontario"
      }
      
      @account = Account.new(attributes)
      
      assert_equal @account.accountid, "account_id_123"
      assert_equal @account.name, "Homer Simpson"
      assert_equal @account.country, "USA"
      assert_equal @account.zipcode, "12345"
      assert_equal @account.province, "Ontario"
    end
    
    # Remote testing in remote testing directory
        
  end
end
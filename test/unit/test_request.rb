require 'helper'

module RubyPsigate
  class TestRequest < Test::Unit::TestCase

    def setup
      @credential = Credential.new(:CID => "test", :UserID => "test", :password => "test")
      Request.credential = @credential
    end
    
    def test_storeid_setter
      assert Request.respond_to?(:storeid=)
    end
    
    def test_storeid_getter
      assert Request.respond_to?(:storeid)
    end

    def test_set_credential_setter_on_class_level
      assert Request.respond_to?(:credential=)
    end
    
    def test_sets_credential
      assert_equal @credential, Request.credential
    end
    
    def test_raises_error_if_credentials_not_from_credential_class
      assert_raises(ArgumentError) {Request.credential = "hello world"}
    end
    
    def test_params_setter
      @request = Request.new
      assert @request.respond_to?(:params=)
    end
    
    def test_raises_error_if_params_is_not_a_hash
      @request = Request.new
      assert_raises(ArgumentError) { @request.params = "Hello World" }
    end
    
    def test_sets_params
      hash = { :Hello => "World" }
      @request = Request.new
      @request.params = hash
      
      assert_equal hash, @request.params
    end
    
  end
end
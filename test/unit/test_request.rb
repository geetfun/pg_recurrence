require 'helper'

module RubyPsigate
  class TestRequest < Test::Unit::TestCase

    def test_set_credential_setter_on_class_level
      assert Request.respond_to?(:credential=)
    end
    
    def test_sets_credential
      credential = Credential.new(:CID => "test", :UserID => "test", :password => "test")
      Request.credential = credential
      assert_equal credential, Request.credential
    end
    
    def test_raises_error_if_credentials_not_from_credential_class
      assert_raises(ArgumentError) {Request.credential = "hello world"}
    end
    
  end
end
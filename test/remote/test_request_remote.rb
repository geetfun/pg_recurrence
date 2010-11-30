require 'helper'

module RubyPsigate
  class TestRequestRemote < Test::Unit::TestCase

    def setup
      Request.credential = credential
      
      @params = {
        :Request => {
          :CID => "1000001",
          :UserID => "teststore",
          :Password => "testpass",
          :Action => "AMA00",
          :Condition => {
            :AccountID => "000000000000000911"
          }
        }
      }
      
      @request = Request.new
      @request.params = @params
      @response = @request.post
    end
    
    def test_retrieves_remote_information_with_post
      assert @response.success?
      assert_equal "RPA-0020", @response.returncode
      assert_equal "Retrive Payment Accounts Information completed successfully.", @response.returnmessage
      assert_equal "Earl Grey", @response.name
      assert_equal "A", @response.status
      assert_equal "000000000000000911", @response.accountid
    end
    
  end
end
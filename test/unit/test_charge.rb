require 'helper'

module RubyPsigate
  class TestCharge < Test::Unit::TestCase
    
    def setup
      Request.credential = credential
    end

    # def test_new_record
    #   @charge = Charge.new
    #   assert @charge.new_record?
    # end
  end
end
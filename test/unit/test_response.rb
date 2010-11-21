require 'helper'

module RubyPsigate
  class TestResponse < Test::Unit::TestCase
    
    def test_accepts_xml
      @response = Response.new(api_response)
      assert @response
    end
    
    private
        
    def api_response
      <<-EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <Response>
        <CID>1000001</CID>
        <Action>REGISTER NEW PAYMENT ACCOUNTS</Action>
        <ReturnCode>RPA-0000</ReturnCode>
        <ReturnMessage>Register Payment Accounts completed successfully.</ReturnMessage>
        <Account>
        <ReturnCode>RPA-0010</ReturnCode>
        <ReturnMessage>Register Payment Account completed successfully.</ReturnMessage>
        <AccountID>2010090412944</AccountID>
        <Status></Status>
        <Name>John Smith</Name>
        <Company>PSiGate Inc.</Company>
        <Address1>145 King St.</Address1>
        <Address2>2300</Address2>
        <City>Toronto</City>
        <Province>Ontario</Province>
        <Postalcode>M5H 1J8</Postalcode>
        <Country>Canada</Country>
        <Phone>1-905-123-4567</Phone>
        <Fax>1-905-123-4568</Fax>
        <Email>support@psigate.com</Email>
        <Comments>No Comment Today</Comments>
        <CardInfo>
        <Status></Status>
        <SerialNo>1</SerialNo>
        <AccountID>2010090412944</AccountID>
        <CardHolder>John Smith</CardHolder>
        <CardNumber>400555...0019</CardNumber>
        <CardExpMonth>08</CardExpMonth>
        <CardExpYear>11</CardExpYear>
        <CardType>VISA</CardType>
        </CardInfo>
        </Account>
      </Response>
      EOF
    end
    
    
  end
end
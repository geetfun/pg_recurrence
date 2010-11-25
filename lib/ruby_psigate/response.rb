module RubyPsigate
  class Response
    
    ACCOUNT_SUCCESS_CODES = %w(
      RPA-0000
      RPA-0001
      RPA-0010
      RPA-0015
      RPA-0020
      RPA-0022
      RPA-0025
      RPA-0040
      RPA-0042
      RPA-0046
      RPA-0048
      RPA-0058
      PSI-0000
      RRC-0000
      RRC-0005
      RRC-0050
      RRC-0060
      RRC-0065
      RRC-0072
      RRC-0075
      RRC-0082
      RRC-0090
      RRC-0092
      RRC-0095
      RRC-0098
      RRC-0190
      CTL-0000
      CTL-0005
      CTL-0050
      CTL-0060
      CTL-0065
      CTL-0072
      CTL-0075
      CTL-0082
      CTL-0090
      CTL-0092
      CTL-0098
      CTL-0190
      CTL-0192
      RIV-0050
      RIV-0060
      RIV-0072
      RIV-0090
      RIV-0190
      RIV-0197
      RIV-0198
      EMR-0000
      EMR-0005
      EMR-0050
      EMR-0060
      EMR-0072
      EMR-0082
      EMR-0090
      EMR-0190
    )
    
    def initialize(xml_response)
      @xml_response = Crack::XML.parse(xml_response)
    end
    
    def response
      @xml_response["Response"]
    end
    
    def success?
      return false unless @xml_response
      ACCOUNT_SUCCESS_CODES.include?(self.returncode)
    end
    
    private
    
    def method_missing(name, *args, &block)
      @result = nil
      name = name.downcase.to_sym
      @result = find_value_in_hash(name, response)
      @result
    end
    
    def find_value_in_hash(input_key, hash)
      result = nil
      hash.each_pair do |key, value|
        if value.is_a? Hash
          result = find_value_in_hash(input_key, value)
        else
          key = key.downcase.to_sym
          result = value if input_key == key
        end
        
        break unless result.nil?
      end
      result
    end
    
  end
end
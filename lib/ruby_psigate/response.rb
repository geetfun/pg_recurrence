module RubyPsigate
  class Response
    
    def initialize(xml_response)
      @xml_response = Crack::XML.parse(xml_response)
      self
    end
    
  end
end
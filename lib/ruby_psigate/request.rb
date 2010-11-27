module RubyPsigate
  class Request
        
    def self.credential
      @@credential
    end
    
    def self.credential=(x)
      raise ArgumentError unless x.is_a?(Credential)
      @@credential = x
    end
    
    def initialize
      @request = {}
      @request[:Request] = {}      
    end

    
  end
end
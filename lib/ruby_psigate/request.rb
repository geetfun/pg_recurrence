module RubyPsigate
  class Request
        
    def self.credential
      @@credential
    end
    
    def self.credential=(x)
      raise ArgumentError unless x.is_a?(Credential)
      @@credential = x
    end
    
    def initialize(attributes={})
      @request = {}
      @request[:Request] = {}
      
      # Add credentials
      %w( CID UserID Password ).each do |c|
        @request[:Request][c.to_sym] = self.class.credential.send((c.downcase).to_sym)
      end
    end
    
    def params=(hash={})
      
    end
    
    def post
      
    end

    
  end
end
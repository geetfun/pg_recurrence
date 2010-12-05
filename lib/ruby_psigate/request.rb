module RubyPsigate
  class Request

    attr_reader :params
    
    class << self
      def credential
        @@credential
      end

      def credential=(x)
        raise ArgumentError unless x.is_a?(Credential)
        @@credential = x
      end
      
      def storeid
        @@storeid
      end
      
      def storeid=(x)
        @@storeid = x
      end
    end
    
    def initialize(attributes={})
      @request = {}
      @request[:Request] = {}
      
      # Add credentials
      %w( CID UserID Password ).each do |c|
        @request[:Request][c.to_sym] = self.class.credential.send((c.downcase).to_sym)
      end
    end
    
    def params=(hash)
      raise ArgumentError unless hash.is_a?(Hash)
      @params = hash
    end
    
    def post
      begin
        parameters = RubyPsigate::Serializer.new(params, :header => true).to_xml
        connection = RubyPsigate::Connection.new(self.class.credential.endpoint)
        response = connection.post(parameters)
        response = Response.new(response)
      rescue ConnectionError => e
        response = nil
      end
      response
    end

    
  end
end
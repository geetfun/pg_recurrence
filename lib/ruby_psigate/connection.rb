module RubyPsigate
    
  class Connection
    
    MAX_RETRIES = 3
    RETRY_SAFE = true
    
    # => Values in seconds
    READ_TIMEOUT = 60
    OPEN_TIMEOUT = 30
    VERIFY_PEER = true
    
    def initialize(endpoint)
      @endpoint = endpoint.is_a?(URI) ? endpoint : URI.parse(endpoint)
      @retry_safe   = RETRY_SAFE
      @read_timeout = READ_TIMEOUT
      @open_timeout = OPEN_TIMEOUT
      @verify_peer  = VERIFY_PEER
    end
    
    attr_reader :endpoint
    attr_accessor :retry_safe
    attr_accessor :read_timeout
    attr_accessor :open_timeout
    attr_accessor :verify_peer
    
    def post(params)
      retry_exceptions do
        begin

          uri = @endpoint
          psigate = Net::HTTP.new(uri.host, uri.port)

          # Configure Timeouts
          psigate.open_timeout = open_timeout
          psigate.read_timeout = read_timeout 

          # Configure SSL
          psigate.use_ssl = true
          if verify_peer
            psigate.verify_mode = OpenSSL::SSL::VERIFY_PEER
            psigate.ca_file     = ca_file
          else
            psigate.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          raw_response = psigate.post(uri.path, params)
          response = handle_response(raw_response)
          response
        rescue EOFError => e
          raise ConnectionError, "The remote server dropped the connection"
        rescue Errno::ECONNRESET => e
          raise ConnectionError, "The remote server reset the connection"
        rescue Errno::ECONNREFUSED => e
          raise RetriableConnectionError, "The remote server refused the connection"
        rescue Timeout::Error, Errno::ETIMEDOUT => e
          raise ConnectionError, "The connection to the remote server timed out"
          
        end # begin
      end # retry_exceptions
    end
    
    private
    
    def ca_file
      ca_file = File.dirname(__FILE__) + '/../certs/cacert.pem'
      raise CertVerificationFileMissingError unless File.exists?(ca_file)
      ca_file
    end
    
    def handle_response(raw_response)
      case raw_response.code.to_i
      when 200..300
        raw_response.body
      else
        raise ResponseError.new(raw_response)
      end
    end
    
    def retry_exceptions(&block)
      retries = MAX_RETRIES
      begin
        yield
      rescue RetriableConnectionError => e
        retries -= 1
        retry unless retries.zero?
        raise ConnectionError, e.message
      rescue ConnectionError
        retries -= 1
        retry if retry_safe && !retries.zero?
        raise
      end
    end
    
  end
end
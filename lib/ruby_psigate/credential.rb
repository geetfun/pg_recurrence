module RubyPsigate
  class Credential
  
    def initialize(options)
      @cid      = options[:CID]
      @userid   = options[:UserID]
      @password = options[:password]
      @mode     = options[:mode] || :test
      
      if @mode == :test
        @endpoint = "https://dev.psigate.com:8645/Messenger/AMMessenger"
      else
        @endpoint = "https://dev.psigate.com:8645/Messenger/AMMessenger"
      end
    end
    
  end
end
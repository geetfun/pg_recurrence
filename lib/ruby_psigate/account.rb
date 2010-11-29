module RubyPsigate
  class Account < Request
    
    attr_accessor :accountid, :name, :company, :address1, :address2, :city, :province, :postalcode, :country, :phone, :fax, :email, :comments
    alias_method :state, :province
    alias_method :state=, :province=
    alias_method :zipcode, :postalcode
    alias_method :zipcode=, :postalcode=
    attr_reader :credit_card

    def credit_card=(credit_card)
      raise ArgumentError unless credit_card.is_a?(PgCreditcard)
      @credit_card = credit_card
    end
    
    def initialize(attributes={})
      attributes.each_pair do |attribute, value|
        if self.respond_to?(attribute)
          setter = "#{attribute}=".to_sym
          self.send(setter, value)
        end
      end
      super
    end
    
    
    def save
      begin
        # Action
        @request[:Request][:Action] = "AMA01"

        # Account Details
        @request[:Request][:Account] = {}
        %w( AccountID Name Company Address1 Address2 City Province Postalcode Country Phone Fax Email Comments ).each do |a|
          value = self.send((a.downcase).to_sym)
          @request[:Request][:Account][a.to_sym] = value if value
        end
    
        # Credit Card
        @request[:Request][:Account][:CardInfo] = {}
        %w( CardHolder CardNumber CardExpMonth CardExpYear ).each do |c|
          value = credit_card.send((c.downcase).to_sym)
          @request[:Request][:Account][:CardInfo][c.to_sym] = value if value
        end
        
        # Creates parameters
        params = RubyPsigate::Serializer.new(@request, :header => true).to_xml
        connection = RubyPsigate::Connection.new(self.class.credential.endpoint)
        response = connection.post(params)
        response = Response.new(response)
        result = response.success? ? true : false
      rescue ConnectionError => e
        result = false
      end
      result
    end

    # 
    # def self.credential=(c)
    #   @credential = c
    # end
    # 
    # def self.credential
    #   @credential
    # end
    # 
    # # Finds an existing account by account_id
    # def self.find(remote_account_id)
    #   begin
    #     # Creates placeholder hash
    #     @request = {}
    #     @request[:Request] = {}
    # 
    #     # Add credentials
    #     %w( CID UserID Password ).each do |c|
    #       @request[:Request][c.to_sym] = credential.send((c.downcase).to_sym)
    #     end
    #     
    #     # Action
    #     @request[:Request][:Action] = "AMA05"
    #     
    #     # Condition
    #     @request[:Request][:Condition] = {:AccountID => remote_account_id}
    #     
    #     # Creates parameters
    #     @params = RubyPsigate::Serializer.new(@request, :header => true).to_xml
    #     @connection = RubyPsigate::Connection.new(credential.endpoint)
    #     @response = @connection.post(@params)
    #     @response = Response.new(@response)
    #     if @response.returnmessage == "No Payment Accounts Information found."
    #       @response = nil
    #     else
    #       attributes = {}
    #       %w( AccountID Status Name Company Address1 Address2 City Province Postalcode Country Phone Fax Email Comments ).each do |a|
    #         attributes[a.downcase.to_sym] = @response.send(a.downcase.to_sym)
    #       end
    #       @account = Account.new(attributes)
    #       @account.credential = credential
    #       @response = @account
    #     end
    #     @response
    #   rescue ConnectionError => e
    #     @response = nil
    #   end
    # end
    # 
    # def self.destroy(remote_account_id)
    #   begin
    #     initialize_request
    #     
    #     # Action
    #     # This will disable the account only
    #     @request[:Request][:Action] = "AMA09"
    #     
    #     # Condition
    #     @request[:Request][:Condition] = {:AccountID => remote_account_id}
    # 
    #     # Creates parameters
    #     @params = RubyPsigate::Serializer.new(@request, :header => true).to_xml
    #     @connection = RubyPsigate::Connection.new(credential.endpoint)
    #     @response = @connection.post(@params)
    #     @response = Response.new(@response)
    #     if @response.returncode == "RPA-0040"
    #       @response = nil
    #     else
    #       @response
    #     end
    #     @response
    #   rescue ConnectionError => e
    #     @response = false
    #   end
    # end
    # 
    # def register
    #   begin
    #     initialize_request
    #     
    #     # Action
    #     @request[:Request][:Action] = "AMA01"
    # 
    #     # Account Details
    #     @request[:Request][:Account] = {}
    #     %w( AccountID Name Company Address1 Address2 City Province Postalcode Country Phone Fax Email Comments ).each do |a|
    #       value = self.send((a.downcase).to_sym)
    #       @request[:Request][:Account][a.to_sym] = value if value
    #     end
    # 
    #     # Credit Card
    #     @request[:Request][:Account][:CardInfo] = {}
    #     %w( CardHolder CardNumber CardExpMonth CardExpYear ).each do |c|
    #       value = credit_card.send((c.downcase).to_sym)
    #       @request[:Request][:Account][:CardInfo][c.to_sym] = value if value
    #     end
    # 
    #     # Creates parameters
    #     @params = RubyPsigate::Serializer.new(@request, :header => true).to_xml
    #     @connection = RubyPsigate::Connection.new(credential.endpoint)
    #     @response = @connection.post(@params)
    #     @response = Response.new(@response)
    #     @response
    #   rescue ConnectionError => e
    #     @response = false
    #   end
    # end
    # 
    # def update
    #   begin
    #     initialize_request
    #     
    #     # Action
    #     @request[:Request][:Action] = "AMA02"
    #     
    #     # Condition
    #     @request[:Request][:Condition] = {:AccountID => accountid}
    #     
    #     # Account Details Update
    #     @request[:Request][:Update] = {}
    #     %w( Name Company Address1 Address2 City Province Postalcode Country Phone Fax Email Comments ).each do |a|
    #       value = self.send((a.downcase).to_sym)
    #       @request[:Request][:Update][a.to_sym] = value if value
    #     end
    #     
    #     # Creates parameters
    #     @params = RubyPsigate::Serializer.new(@request, :header => true).to_xml
    #     @connection = RubyPsigate::Connection.new(credential.endpoint)
    #     @response = @connection.post(@params)
    #     @response = Response.new(@response)
    #     @response
    #   rescue ConnectionError => e
    #     @response = false
    #   end
    #   
    # end
    # 
    # def charge
    #   # TODO      
    # end
    # 
    # def refund
    #   # TODO
    # end
    # 
    # private
    # 
    # def initialize_request
    #   # Creates placeholder hash
    #   @request = {}
    #   @request[:Request] = {}
    #   
    #   # Add credentials
    #   %w( CID UserID Password ).each do |c|
    #     @request[:Request][c.to_sym] = credential.send((c.downcase).to_sym)
    #   end
    # end
    
  end
end
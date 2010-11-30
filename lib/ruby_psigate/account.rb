module RubyPsigate
  class Account < Request
    
    attr_accessor :accountid, :name, :company, :address1, :address2, :city, :province, :postalcode, :country, :phone, :fax, :email, :comments, :status, :error
    attr_accessor :returnmessage, :returncode, :action
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
        if !credit_card.nil? && credit_card.valid?
          @request[:Request][:Account][:CardInfo] = {}
          %w( CardHolder CardNumber CardExpMonth CardExpYear ).each do |c|
            value = credit_card.send((c.downcase).to_sym)
            @request[:Request][:Account][:CardInfo][c.to_sym] = value if value
          end
        end
        
        # Creates parameters
        params = RubyPsigate::Serializer.new(@request, :header => true).to_xml
        connection = RubyPsigate::Connection.new(self.class.credential.endpoint)
        response = connection.post(params)
        response = Response.new(response)

        if response.success? && response.returncode == "RPA-0000"
          %w( accountid name company address1 address2 city province postalcode country phone fax comments ).each do |attribute|
            self.send("#{attribute}=".to_sym, response.send(attribute.to_sym))
          end
          
          # Need to refactor this
          attributes[:status] = response.response["Account"]["Status"]
          
          result = true
        else
          self.send(:error=, response.returnmessage)
          result = false
        end
      rescue ConnectionError => e
        result = false
      end
      result
    end
    
    def self.find(accountid)
      begin
        params = {
          :Request => {
            :CID => credential.cid,
            :UserID => credential.userid,
            :Password => credential.password,
            :Action => "AMA05",
            :Condition => { :AccountID => accountid }
          }
        }
        
        @result = Request.new
        @result.params = params
        @result = @result.post
        
        raise "#{@result.inspect}"      
        

        if @result.returncode == "RPA-0020"
          # Adds basic attributes
          attributes = {}
          %w( AccountID Name Company Address1 Address2 City Province Postalcode Country Phone Fax Email Comments ).each do |attribute|
            attributes[attribute.downcase.to_sym] = @result.send(attribute.downcase.to_sym)
          end
          
          attributes[:status] = @result.response["Account"]["Status"]
          
          # Back end info
          %w( returnmessage returncode action ).each do |info|
            attributes[info.downcase.to_sym] = @result.send(info.downcase.to_sym)
          end
          
          # Adds credit card attribute
          %w( status serialno cardholder cardnumber cardexpmonth cardexpyear cardtype ).each do |cc|
            # TODO
          end
          
          @account = Account.new(attributes)
        else
          @account = nil
        end
      rescue ConnectionError => e
        @account = nil
      end
      @account
    end

    def self.disable(accountid)
      begin
        params = {
          :Request => {
            :CID => credential.cid,
            :UserID => credential.userid,
            :Password => credential.password,
            :Action => "AMA09",
            :Condition => { :AccountID => accountid }            
          }
        }
        
        result = Request.new
        result.params = params
        result = result.post  
        response = result.returncode == "RPA-0040" ? true : false
      rescue ConnectionError => e
        response = false
      end
      response
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
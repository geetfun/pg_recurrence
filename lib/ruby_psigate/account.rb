module RubyPsigate
  class Account < Request
    
    attr_accessor :accountid, :name, :company, :address1, :address2, :city, :province, :postalcode, :country, :phone, :fax, :email, :comments, :status, :error
    attr_accessor :returnmessage, :returncode, :action, :response
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
    
    def attributes=(attributes={})
      attributes.each_pair do |attribute, value|
        if self.respond_to?(attribute)
          setter = "#{attribute}=".to_sym
          self.send(setter, value)
        end
      end
    end
    
    def new_record?
      status.nil? ? true : false
    end
    
    def save
      begin
        # Action
        action = new_record? ? "AMA01" : "AMA02"
        @request[:Request][:Action] = action

        if new_record?
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
        else # Is an update
          # Set account ID
          @request[:Request][:Condition] = {:AccountID => accountid}
          
          @request[:Request][:Update] = {}
          %w( Name Company Address1 Address2 City Province Postalcode Country Phone Fax Email Comments ).each do |a|
            value = self.send((a.downcase).to_sym)
            @request[:Request][:Update][a.to_sym] = value if value
          end
        end
        
        # Creates parameters
        params = RubyPsigate::Serializer.new(@request, :header => true).to_xml
        connection = RubyPsigate::Connection.new(self.class.credential.endpoint)
        response = connection.post(params)
        response = Response.new(response)
        self.response = response

        if response.success? && (response.returncode == "RPA-0000" && new_record?) || (response.returncode == "RPA-0022" && !new_record?)
          %w( accountid name company address1 address2 city province postalcode country phone fax comments ).each do |attribute|
            self.send("#{attribute}=".to_sym, response.send(attribute.to_sym))
          end          
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
    
    def self.enable(accountid)
      response = self.do(:action => "AMA08", :accountid => accountid, :success => "RPA-0046")
      response      
    end

    def self.disable(accountid)
      response = self.do(:action => "AMA09", :accountid => accountid, :success => "RPA-0040")
      response
    end
    
    private
    
    def self.do(opts = {})
      action = opts[:action]
      accountid = opts[:accountid]
      success = opts[:success]
      begin
        params = {
          :Request => {
            :CID => credential.cid,
            :UserID => credential.userid,
            :Password => credential.password,
            :Action => action,
            :Condition => { :AccountID => accountid }            
          }
        }
        
        result = Request.new
        result.params = params
        result = result.post  
        response = result.returncode == success ? true : false
      rescue ConnectionError => e
        response = false
      end
      response
    end
    
  end
end
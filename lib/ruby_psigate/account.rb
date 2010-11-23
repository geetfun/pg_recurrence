module RubyPsigate
  class Account
    
    attr_accessor :account_id
    attr_accessor :name, :company, :email, :comments
    attr_accessor :address1, :address2, :city, :province, :postal_code, :country, :phone, :fax
    
    alias_method :accountid, :account_id
    alias_method :state, :province
    alias_method :state=, :province=
    alias_method :zipcode, :postal_code
    alias_method :zipcode=, :postal_code=
    alias_method :postalcode, :postal_code
    
    attr_reader :credit_card, :credential
    
    def initialize(attributes={})
      attributes.each_pair do |attribute, value|
        if self.respond_to?(attribute)
          setter = "#{attribute}=".to_sym
          self.send(setter, value)
        end
      end
    end
    
    def credential=(credential_object)
      raise ArgumentError unless credential_object.is_a?(Credential)
      @credential = credential_object
    end
    
    def credit_card=(cc_object)
      raise ArgumentError unless cc_object.is_a?(PgCreditcard)
      @credit_card = cc_object
    end
    
    def register
      # Creates placeholder hash
      @request = {}
      @request[:Request] = {}
      
      # Add credentials
      %w( CID UserID Password ).each do |c|
        @request[:Request][c.to_sym] = credential.send((c.downcase).to_sym)
      end
      
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
      @params = RubyPsigate::Serializer.new(@request, :header => true).to_xml
      @connection = RubyPsigate::Connection.new(credential.endpoint)
      @response = @connection.post(@params)
      @response = Response.new(@response)
      @response
    end
    
  end
end
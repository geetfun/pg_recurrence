module RubyPsigate
  class Charge < Request
    
    attr_accessor :accountid, :status, :productid, :quantity, :price, :interval, :rbtrigger, :starttime, :endtime, :response, :rbname, :rbcid
    
    def self.serialno
      @serialno
    end
    
    def self.serialno=(x)
      @serialno=x
    end
    
    def self.find(rbcid)
      begin
        params = {
          :Request => {
            :CID => credential.cid,
            :UserID => credential.userid,
            :Password => credential.password,
            :Action => "RBC00",
            :Condition => { :RBCID => rbcid }
          }
        }
        
        @result = Request.new
        @result.params = params
        @result = @result.post
        
        if @result.returncode == "RRC-0060"
          # Adds basic attributes
          attributes = {}
          %w( rbcid interval trigger status ).each do |info|
            attributes[info.downcase.to_sym] = @result.send(info.downcase.to_sym)
          end
          
          attributes["starttime"] = @result.startdate
          attributes["endtime"] = @result.enddate
          attributes["response"] = @result.response
          
          @charge = Charge.new(attributes)
        else
          @charge = nil
        end
      rescue ConnectionError => e
        @charge = nil
      end
      @charge
    end
    
    def self.update(options={})
      rbname = options[:rbname]
      rbcid = options[:rbcid]
      serialno = options[:serialno]
      interval = options[:interval]
      rbtrigger = options[:rbtrigger]
      starttime = options[:starttime]
      endtime = options[:endtime]
      
      begin
        params = {
          :Request => {
            :CID => credential.cid,
            :UserID => credential.userid,
            :Password => credential.password,
            :Action => "RBC02",
            :Condition => { :RBCID => rbcid },
            :Update => {
              :RBName => rbname,
              :SerialNo => serialno,
              :Interval => interval,
              :RBTrigger => rbtrigger,
              :StartTime => starttime,
              :EndTime => endtime
            }
          }
        }
        
        @result = Request.new
        @result.params = params
        @result = @result.post

        if @result.returncode = "RRC-0072"
          result = true
        else
          result = false
        end
      rescue ConnectionError => e
        result = false
      end
      result
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
    
    # def new_record?
    #   response["Invoice"]["Status"] == "Paid" ? false : true
    # end
    
    # Creates (adds) or Updates recurring charges
    def save
      raise ArgumentError, "StoreID is not specified in superclass" if self.class.storeid.nil?
      begin
        @request[:Request][:Action] = "RBC01"
        @request[:Request][:Charge] = {
          :RBName => rbname,
          :StoreID => self.class.storeid,
          :SerialNo => self.class.serialno,
          :AccountID => accountid,
          :Interval => interval,
          :RBTrigger => rbtrigger,
          :StartTime => starttime,
          :EndTime => endtime,
          :ItemInfo => {
            :ProductID => productid,
            :Quantity => quantity,
            :Price => price
          }
        }
                
        # Creates parameters
        params = RubyPsigate::Serializer.new(@request, :header => true).to_xml        
        connection = RubyPsigate::Connection.new(self.class.credential.endpoint)
        response = connection.post(params)        
        response = Response.new(response)
        self.response = response
                
        if response.success? && response.returncode == "RRC-0000"
          self.rbcid = response.rbcid
          result = true
        else
          result = false
        end
      rescue ConnectionError => e
        result = false
      end
      result
    end
    
    # Deletes a recurring charge
    def destroy
      
    end
    
    # Toggles a charge to be active or inactive
    def toggle(action = :on)
      
    end
    
    # Immediately charges the credit card
    def immediately
      raise ArgumentError, "StoreID is not specified in superclass" if self.class.storeid.nil?
      begin
        @request[:Request][:Action] = "RBC99"
        @request[:Request][:Charge] = {
          :StoreID => self.class.storeid,
          :SerialNo => self.class.serialno,
          :AccountID => accountid,
          :ItemInfo => {
            :ProductID => productid,
            :Quantity => quantity,
            :Price => price
          }
        }
        
        # Creates parameters
        params = RubyPsigate::Serializer.new(@request, :header => true).to_xml        
        connection = RubyPsigate::Connection.new(self.class.credential.endpoint)
        response = connection.post(params)        
        response = Response.new(response)
        self.response = response
        
        if response.success? && response.returncode == "PSI-0000" 
          result = true
        else
          result = false
        end
      rescue ConnectionError => e
        result = false
      end
      result
    end
    
  end
end
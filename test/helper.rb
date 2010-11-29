require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'pg_recurrence'

class Test::Unit::TestCase
  
  # Helpers
  def credential
    @credential = RubyPsigate::Credential.new(:CID => "1000001", :UserID => "teststore", :password => "testpass")
  end
  
  def credit_card
    @credit_card = PgCreditcard.new(
      :name => "Homer Simpsons",
      :number => "4111111111111111",
      :month  => "03",
      :year   => "20",
      :cvv    => "123"
    )
  end
  
  def valid_account_attributes
    {
      :name => "Homer Simpson",
      :email => "homer@simpsons.com",
      :address1 => "1234 Evergrove Drive",
      :address2 => nil,
      :city => "Toronto",
      :province => "ON",
      :postal_code => "M2N3A3",
      :country => "CA",
      :phone => "416-111-1111",
      :credit_card => credit_card
    }
  end
  
  def create_account
    @account = Account.new(
      :name => "Homer Simpson",
      :email => "homer@simpsons.com",
      :address1 => "1234 Evergrove Drive",
      :address2 => nil,
      :city => "Toronto",
      :province => "ON",
      :postal_code => "M2N3A3",
      :country => "CA",
      :phone => "416-111-1111",
      :credit_card => @credit_card,
      :credentials => @credential
    )

    result = @account.register
    result
  end
  
  
end

require 'mocha'

require 'rubygems'
require 'watir'
 
class SingleTest
  @username = ""
  @access_key = ""
  @caps = {}

  def initialize(options={})
    @username = ENV['BROWSERSTACK_USERNAME'] || options[:user]
    @access_key = ENV['BROWSERSTACK_ACCESS_KEY'] || options[:key]
    @caps = options[:caps]
  end

  def google_test
    begin
      url = "https://#{@username}:#{@access_key}@hub-cloud.browserstack.com/wd/hub"
      @browser = Watir::Browser.new(:remote, :url => url, :desired_capabilities => @caps)

      @browser.goto "http://www.google.com/ncr"
      @browser.element(:name => "q" )
      @browser.input(:id => 'lst-ib').send_keys "BrowserStack"
      raise "Exception" if not @browser.title.match(/Google/i)
      puts "Google Test completed without errors"
    ensure
      @browser.quit
    end
  end
end

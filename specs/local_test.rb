require 'rubygems'
require 'watir'
 
class LocalTest
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

      @browser.goto "http://bs-local.com:45691/check"
      raise "Exception" if not @browser.html.match(/Up and Running/i)
      puts "Local Test completed without errors"
    ensure
      @browser.quit
    end
  end
end

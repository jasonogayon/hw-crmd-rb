# Add browser driver paths
BROWSERS_DIRECTORY = File.absolute_path('../..', File.dirname(__FILE__))
chromedriver = (windows == :true) ? "chromedriver.exe" : "chromedriver"
geckodriver = (windows == :true) ? "geckodriver.exe" : "geckodriver"
chromedriver_path = File.join(BROWSERS_DIRECTORY, "browsers", chromedriver)
geckodriver_path = File.join(BROWSERS_DIRECTORY, "browsers", geckodriver)
driver_path = (browser == :firefox) ? geckodriver_path : chromedriver_path

# Add SSL certificate
ENV['SSL_CERT_FILE'] = "#{File.expand_path(File.dirname(__FILE__))}/cacert.pem"

# Start browser on a desired environment
unless browser == :none
    if mobile == :true
        capabilities = Webdriver::UserAgent.driver(browser: browser, driver_path: driver_path)
    else
        if browser == :firefox
            capabilities = Selenium::WebDriver.for :firefox, driver_path: driver_path
        else
            options = Selenium::WebDriver::Chrome::Options.new
            options.add_argument('--ignore-certificate-errors')
            options.add_argument('--disable-popup-blocking')
            options.add_argument('--disable-translate')
            capabilities = Selenium::WebDriver.for :chrome, options: options, driver_path: driver_path
        end
    end
    browser = Watir::Browser.new capabilities
end


Before do |scenario|
    begin
        tries ||= 3
        unless browser == :none
            @browser = browser
            @browser.cookies.clear
        end
    rescue
        retry unless (tries -= 1).zero?
    end
end

at_exit do
    browser.close unless browser.nil?
end

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
            begin
                tries ||= 1
                capabilities = Selenium::WebDriver.for :firefox, driver_path: driver_path
            rescue Selenium::WebDriver::Error::WebDriverError
                puts "You seem to be running the test suite on a Windows machine without setting the WINDOWS=true option in the terminal"
                puts "Automatically selecting the proper browser driver ..."
                driver_path = File.join(BROWSERS_DIRECTORY, "browsers", "geckodriver.exe")
                capabilities = Selenium::WebDriver.for :firefox, driver_path: driver_path
                retry unless (tries -= 1).zero?
            end
        else
            begin
                tries ||= 1
                options = Selenium::WebDriver::Chrome::Options.new
                options.add_argument('--ignore-certificate-errors')
                options.add_argument('--disable-popup-blocking')
                options.add_argument('--disable-translate')
                options.add_argument('--start-maximized')
                capabilities = Selenium::WebDriver.for :chrome, options: options, driver_path: driver_path
            rescue Selenium::WebDriver::Error::WebDriverError
                puts "You seem to be running the test suite on a Windows machine without setting the WINDOWS=true option in the terminal"
                puts "Automatically selecting the proper browser driver ..."
                driver_path = File.join(BROWSERS_DIRECTORY, "browsers", "chromedriver.exe")
                capabilities = Selenium::WebDriver.for :chrome, options: options, driver_path: driver_path
                retry unless (tries -= 1).zero?
            end
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

# Add browser driver paths
BROWSERS_DIRECTORY = File.absolute_path('../..', File.dirname(__FILE__))
chromedriver_path = File.join(BROWSERS_DIRECTORY,"browsers","chromedriver") if mac == :true
chromedriver_path ||= File.join(BROWSERS_DIRECTORY,"browsers","chromedriver.exe")
geckodriver_path = File.join(BROWSERS_DIRECTORY,"browsers","geckodriver.exe")

# Add SSL certificate
ENV['SSL_CERT_FILE'] = "#{File.expand_path(File.dirname(__FILE__))}/cacert.pem"

# Start browser on a desired environment
unless browser == :none
    arguments = "--ignore-certificate-errors --disable-popup-blocking --disable-translate --disable-web-security --disable-infobars --start-maximized"
    if machine == :local
        capabilities = Selenium::WebDriver.for :firefox, driver_path: geckodriver_path if browser == :firefox
        capabilities = Webdriver::UserAgent.driver(:browser => browser, :agent => :iphone, :orientation => :portrait, :driver_path => chromedriver_path) if mobile == :true
        capabilities ||= Selenium::WebDriver.for :chrome, switches: [arguments], driver_path: chromedriver_path
    else
        capabilities = Selenium::WebDriver::Remote::Capabilities.firefox :profile => 'default', driver_path: geckodriver_path if browser == :firefox
        capabilities ||= Selenium::WebDriver::Remote::Capabilities.chrome :chromeOptions => {:args => [arguments]}, driver_path: chromedriver_path
    end

    unless machine == :local
        case machine
            when :revolver then remote_ip = "10.1.2.207"
            when :webdriver1 then remote_ip = "10.1.2.189"
        end
        browser = Watir::Browser.new :remote, :url => "http://#{remote_ip}:5555/wd/hub", :desired_capabilities => capabilities
    end
    browser ||= Watir::Browser.new capabilities
end


Before do |scenario|
    begin
        tries ||= 3
        unless browser == :none
            @browser = browser
            @browser.cookies.clear
            # @browser.driver.manage.window.maximize if mobile == :true
        end
    rescue
        retry unless (tries -= 1).zero?
    end
end

at_exit do
    browser.close unless browser.nil?
end
require 'rspec'
require 'page-object'
require 'fig_newton'
require 'require_all'
require 'parallel_tests'
require 'selenium-webdriver'
require 'watir'
require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'
require 'webdriver-user-agent'
require 'date'
require 'gmail'
require 'roo'
require 'write_xlsx'
require 'json'

World(PageObject::PageFactory)

def browser
    (ENV['BROWSER'] ||= 'chrome').downcase.to_sym
end

def machine
    (ENV['MACHINE'] ||= 'local').downcase.to_sym
end

def mobile
    (ENV['MOBILE'] ||= 'false').downcase.to_sym
end

def mac
    (ENV['MAC'] ||= 'false').downcase.to_sym
end

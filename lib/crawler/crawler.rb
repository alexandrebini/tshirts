require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'csv'
require 'singleton'

module Crawler
  autoload :UrlOpener,        File.expand_path('../base/url_opener', __FILE__)
  autoload :Worker,           File.expand_path('../base/worker', __FILE__)
  autoload :ActMacro,         File.expand_path('../base/act_macro', __FILE__)
  autoload :ClassMethods,     File.expand_path('../base/class_methods', __FILE__)
  autoload :InstanceMethods,  File.expand_path('../base/instance_methods', __FILE__)

  autoload :Chicorei,         File.expand_path('../chicorei', __FILE__)
  autoload :Redbug,           File.expand_path('../redbug', __FILE__)
  autoload :Vandal,           File.expand_path('../vandal', __FILE__)
end
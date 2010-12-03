require 'rubygems'
gem 'rack'
require 'rack'
require 'erb'

module Lunetas
  base_dir = File.dirname(__FILE__) + '/lunetas/'
  autoload :Bag,   base_dir + 'bag.rb'
  autoload :Candy, base_dir + 'candy.rb'
  autoload :Error, base_dir + 'error.rb'
end


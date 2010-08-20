require 'rubygems'
gem 'rack'
require 'rack'

module Lunetas
  base_dir = File.dirname(__FILE__) + '/lunetas/'
  autoload :Candy, base_dir + 'candy.rb'
  autoload :Bag, base_dir + 'bag.rb'
  autoload :Error, base_dir + 'error.rb'
end


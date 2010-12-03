# This module should be included in any resource that should be exposed with
# an API. Then the method matches should be called in order to register the
# path for this resource.
# @example Simple example
#   class Testing
#     include Lunetas::Candy
#     matches '/test'
#
#     def get
#       "This is what I answer then calling GET '/test'"
#     end
#   end
module Lunetas::Candy
  base_dir = File.dirname(__FILE__) + '/candy/'
  autoload :Initialization,  base_dir + 'initialization.rb'
  autoload :MethodStrategy,  base_dir + 'method_strategy.rb'
  autoload :RequestWrapper,  base_dir + 'request_wrapper.rb'
  autoload :ResponseHandler, base_dir + 'response_handler.rb'
  autoload :TemplateParsing, base_dir + 'template_parsing.rb'

  # @private
  def self.included(receiver)
    receiver.send :include, Initialization::InstanceMethods
    receiver.send :extend,  Initialization::ClassMethods
    receiver.send :include, MethodStrategy::InstanceMethods
    receiver.send :include, RequestWrapper::InstanceMethods
    receiver.send :include, ResponseHandler::InstanceMethods
    receiver.send :extend,  ResponseHandler::ClassMethods
    receiver.send :include, TemplateParsing::InstanceMethods
  end
end

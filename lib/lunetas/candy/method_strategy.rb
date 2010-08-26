# This is an 'abstract' class for the response of the call.
# The methods here can and should be overwritten. If they're
# not (the http methods) will raise an exception, telling that
# this method is not allowed for this route.
module Lunetas::Candy::MethodStrategy
  module InstanceMethods
    # Called before getting the response. Useful to set instance
    # variables that will be used in the methods. Analog to a
    # before filter in Rails.
    # @return [nil]
    def before
      nil
    end

    # The response of the GET HTTP method.
    # @raise [Lunetas::Error::APIError] if the method is not
    #  overwritten.
    # @return [nil]
    def get
      raise Lunetas::Error::APIError
    end

    # The response of the POST HTTP method.
    # @raise [Lunetas::Error::APIError] if the method is not
    #  overwritten.
    # @return [nil]
    def post
      raise Lunetas::Error::APIError
    end

    # The response of the PUT HTTP method.
    # @raise [Lunetas::Error::APIError] if the method is not
    #  overwritten.
    # @return [nil]
    def put
      raise Lunetas::Error::APIError
    end

    # The response of the DELETE HTTP method.
    # @raise [Lunetas::Error::APIError] if the method is not
    #  overwritten.
    # @return [nil]
    def delete
      raise Lunetas::Error::APIError
    end

    # The response of the HEAD HTTP method.
    # @raise [Lunetas::Error::APIError] if the method is not
    #  overwritten.
    # @return [nil]
    def head
      raise Lunetas::Error::APIError
    end

    # The response of the TRACE HTTP method.
    # @raise [Lunetas::Error::APIError] if the method is not
    #  overwritten.
    # @return [nil]
    def trace
      raise Lunetas::Error::APIError
    end

    # The response of the OPTIONS HTTP method.
    # @raise [Lunetas::Error::APIError] if the method is not
    #  overwritten.
    # @return [nil]
    def options
      raise Lunetas::Error::APIError
    end

    # The response of the any other HTTP method.
    # @raise [Lunetas::Error::APIError] if the method is not
    #  overwritten.
    # @param [String] verb the HTTP method that was called from.
    # @return [nil]
    def other_verb(verb)
      raise Lunetas::Error::APIError
    end
  end
end

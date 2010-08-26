# This module is a Wrapper for the request object. It exposes
# several methods in order to get the session, params, etc.
module Lunetas::Candy::RequestWrapper
  module InstanceMethods
    # Called from an XML Http Request?
    # @return [true, false]
    def xhr?
      @req.xhr?
    end

    # Gets the request parameters.
    # @return [Hash]
    def params
      @req.params
    end

    # Gets the current request object.
    # @return [Rack::Request]
    def request
      @req
    end

    # Gets the current session.
    # @return [Hash]
    def session
      @req.session
    end

    # Redirects to some location.
    # @param [String] target the location to redirect to.
    # @param [Fixnum] status the redirect status.
    # @return [nil]
    def redirect(target, status = 302)
      @lunetas_redirect = [status, {'Content-Type' => 'text/plain', 'Location' => target}, []]
    end

    # Is lunetas running in development?
    # @return [true, false]
    def development?
      if ENV['RAILS_ENV']
        ENV['RAILS_ENV'] == 'development'
      else
        ENV['RACK_ENV'].nil? || ENV['RACK_ENV'] == 'development'
      end
    end
  end
end


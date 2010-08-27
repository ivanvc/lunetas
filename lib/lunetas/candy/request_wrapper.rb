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
      set_header 'Location', target
      @lunetas_redirect = [302, "Moved to #{target}"]
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

    # Sets the ContentType for this instance. This overrides the class
    # ContentType.
    # @param [String] content_type the ContentType.
    # @return [nil]
    def set_content_type(content_type)
      set_header 'Content-Type', content_type
    end

    # Sets a Header for this instance.
    # @param [String, Symbol] header the Header to be set.
    # @param [String] value the value of the Header.
    # @return [nil]
    def set_header(header, value)
      @lunetas_headers[header.to_s] = value
    end
  end
end


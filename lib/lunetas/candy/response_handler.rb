# Handles the response to the client. Has the call method to
# be called from Rack.
module Lunetas::Candy::ResponseHandler
  module InstanceMethods
    # Handles the rack call. Delegates it to the method
    # that matches the request method.
    # @return [Array] a Rack::Request response.
    def handle_call
      case @req.request_method
      when 'GET'     then get
      when 'POST'    then post
      when 'PUT'     then put
      when 'DELETE'  then delete
      when 'HEAD'    then head
      when 'TRACE'   then trace
      when 'OPTIONS' then options
      else
        response = other_verb(@req.request_method)
        raise Lunetas::Error::APIError unless response
        response
      end
    end

    # Bites the Candy (a.k.a process this resource). 
    #
    # @return [Array] a standard rack response.
    def bite
      raise @_error if @_error
      before
      response(handle_call)
    rescue Exception => e
      code, error = 500, e
      if Lunetas::Error::BaseError === e
        code = e.code
      elsif development?
        error = "Error: #{e.message}\nBacktrace: #{e.backtrace.join("\n")}"
      end
      response(error, code)
    end

    # Returns the url parameter from the regular expresion. If a captured
    # block is given, then they will be added in order of appearance.
    # @param [Fixnum] index the index of the captured block.
    # @return [String] the captured block.
    def url_param(index)
      @lunetas_url_instance_params[index]
    end

    private
      # A Rack::Request response with the specified content type.
      # @param [Object#to_s] object the object that will be the
      #  response.
      # @param [Fixnum] code the response code.
      # @return [Array] a Rack::Request response.
      def response(object, code = 200)
        @lunetas_headers['Content-Type'] ||= self.class.lunetas_content_type
        if @lunetas_redirect
          code, object = @lunetas_redirect
        end
        [code, @lunetas_headers, [object.to_s]]
      end
  end
  
  module ClassMethods
    # Support to be runned as a Rails Metal.
    # @param [Hash] env the Rack env.
    # @return [Array] a standard Rack response.
    def call(env)
      url_match = env['PATH_INFO'].match(lunetas_regex)
      if url_match
        candy = new(env, url_match.to_a)
        candy.bite
      else
        [404, {"Content-Type" => "text/html", "X-Cascade" => "pass"}, ["Not Found"]]
      end
    end
  end
end

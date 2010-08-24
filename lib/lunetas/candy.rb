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
  module InstanceMethods
    # The matched url-regex for this resource.
    attr_reader :url
    attr_accessor :url_params
    # The initialization of a class that includes a Candy, should be done
    # with rack environment and the url matches from its regular expression.
    # It will register all the passed url parameters from #matches as new
    # instance variables.
    # @param [Hash] env the Rack env.
    # @param [Array] url_matches the matches from its regex. In most cases
    #   (MatchData instance).to_a
    def initialize(env, url_matches)
      @req = Rack::Request.new(env)
      @_url_params = url_matches
      self.url_params = url_matches
      @url = @_url_params.shift
      begin
        self.class._url_params.each_with_index do |option, index|
          instance_variable_set "@#{option}", url_param(index)
        end
        # Provide an authentication method. Probably a method
        # from the Lunetas::Bag.
        #   authenticate!
        # rescue Lunetas::Error::AuthenticationError
        #   @_error = Lunetas::Error::AuthenticationError
      end
    end

    # Returns the url parameter from the regular expresion. If a captured
    # block is given, then they will be added in order of appearance.
    # @param [Fixnum] index the index of the captured block.
    # @return [String] the captured block.
    def url_param(index)
      @_url_params[index]
    end
  
    # Bites the Candy (a.k.a process this resource). 
    #
    # @return [Array] a standard rack response.
    def bite
      raise @_error if @_error
      before
      response(handle_call)
    rescue Exception => e
      response(e, e.code)
    end

    private
      def handle_call
        case @req.request_method
        when 'GET'
          get
        when 'POST'
          post
        when 'PUT'
          put
        when 'DELETE'
          delete
        when 'HEAD'
          head
        when 'TRACE'
          trace
        when 'OPTIONS'
          options
        else
          response = other_verb(@req.request_method)
          raise Lunetas::Error::APIError unless response
          response
        end
      end

      def xhr?
        @req.xhr?
      end

      def params
        @req.params
      end

      # TODO: Polish this
      # def authenticate!
      #   @current_user = User.where(:single_access_token => token).first
      #   raise Lunetas::Error::AuthenticationError unless @current_user
      # end

      def response(object, code = 200)
        [code, {'Content-Type' => self.class.content_type}, [object.to_s]]
      end

      # The following methods should be overwritten by the including class
      def before
        nil
      end

      def get
        raise Lunetas::Error::APIError
      end

      def post
        raise Lunetas::Error::APIError
      end

      def put
        raise Lunetas::Error::APIError
      end

      def delete
        raise Lunetas::Error::APIError
      end

      def head
        raise Lunetas::Error::APIError
      end

      def trace
        raise Lunetas::Error::APIError
      end

      def options
        raise Lunetas::Error::APIError
      end

      def other_verb(verb)
        raise Lunetas::Error::APIError
      end
  end
  
  module ClassMethods
    attr_reader :_url_params
    attr_reader :content_type

    # Support to be runned as a Rails Metal. 
    # @param [Hash] env the Rack env.
    # @return [Array] a standard Rack response.
    def call(env)
      url_match = env['PATH_INFO'].match(@_regex)
      if url_match
        call = new(env, url_match.to_a)
        call.process
      else
        [404, {"Content-Type" => "text/html", "X-Cascade" => "pass"}, ["Not Found"]]
      end
    end

    private
      # Registers a new regular expression. Will add it to the Lunetas::Bag.
      # Will convert the regex to a Regular Expression, if passing a String. It
      # also receives the instance variables for the matches of the regex.
      # @example Regular expression as a Regexp
      #   matches /\/test\/\w+/
      # @example Regular expression as a double quoted string
      #   matches "\\/test\\/\\w+"
      # @example Regular expression as a single quoted string (my favorite)
      #   matches '/test/\w+'
      # @example Passing instance variables that will be set for the captures
      #   matches '/test/(\d+)\.(\w+)', :id, :format
      # @param [String, Regexp] regex the regular expression for this resource.
      # @param [Array<Symbol, String>] url_params the instance variables that will
      #   be set for the captures from the regex.
      def matches(regex, *url_params)
        @content_type = 'text/html'
        @_regex = regex
        unless Regexp === @_regex
          @_regex = Regexp.new(@_regex)
        end
        @_url_params = url_params
        Lunetas::Bag.register(@_regex, self)
      end

      # Sets the Content Type for this URL. Defaults to text/html.
      # @param [String] content_type the ContentType for the response.
      def set_content_type(content_type)
        @content_type = content_type
      end
  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.send :extend, ClassMethods
  end
end

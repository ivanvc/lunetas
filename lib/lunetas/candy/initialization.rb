module Lunetas::Candy::Initialization
  module InstanceMethods
    # The matched url-regex for this resource.
    attr_reader :url
    # The url parameters hold by the instance.
    attr_reader :lunetas_url_instance_params

    # The initialization of a class that includes a Candy, should be done
    # with rack environment and the url matches from its regular expression.
    # It will register all the passed url parameters from #matches as new
    # instance variables.
    # @param [Hash] env the Rack env.
    # @param [Array] url_matches the matches from its regex. In most cases
    #   (MatchData instance).to_a
    def initialize(env, url_matches)
      @req = Rack::Request.new(env)
      @lunetas_url_instance_params = url_matches
      @url = @lunetas_url_instance_params.shift
      begin
        self.class.lunetas_url_params.each_with_index do |option, index|
          instance_variable_set "@#{option}", url_param(index)
        end
        # Provide an authentication method. Probably a method
        # from the Lunetas::Bag.
        #   authenticate!
        # rescue Lunetas::Error::AuthenticationError
        #   @_error = Lunetas::Error::AuthenticationError
      end
    end
  end

  module ClassMethods
    # Holds the URL params, this will be created as instance 
    # variables when the class is initialized.
    attr_reader :lunetas_url_params
    # Holds the Content Type for this request.
    attr_reader :lunetas_content_type
    # Holds the Regular Expression for this class.
    attr_reader :lunetas_regex

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
      @lunetas_content_type = 'text/html'
      @lunetas_regex = regex
      unless Regexp === lunetas_regex
        @lunetas_regex = Regexp.new(regex)
      end
      @lunetas_url_params = url_params
      Lunetas::Bag.register(lunetas_regex, self)
    end

    # Sets the Content Type for this URL. Defaults to text/html.
    # @param [String] content_type the ContentType for the response.
    def set_content_type(content_type)
      @lunetas_content_type = content_type
    end
  end
end

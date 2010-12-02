# This is the module that keeps the register of all the Lunetas. It will add the 
# classes to a register, and whenever rack receives a call, it delegates it.
# If Lunetas is not run as a stand alone rack application, then this module
# lacks of responsability, ie. Running as a Rails Metal.
module Lunetas::Bag
  # Registers new classes to a given regular expression. It should be called from
  # a Luneta.
  # @param [Regexp] regex the regular expression for this Luneta Class.
  # @param [Luneta] candy the class that owns the regular expresion.
  def self.register(regex, candy)
    # TODO: Log: "Registering #{regex.inspect} #{candy.inspect}"
    @@candies ||= {}
    @@candies[regex] = candy
  end

  # Specifies where the public assets are located.
  # @param [String] directory where the assets are located.
  # @raise [Lunetas::Error::NoSuchDirectory] if the directory does not exists.
  def self.set_public_directory(directory)
    unless File.directory? File.expand_path(directory)
      raise Lunetas::Error::NoSuchDirectory
    end
    @@public_directory = File.expand_path(directory)
  end

  # Gets the public directory of assets.
  # @return [String] the location, if not set public/
  def self.public_directory
    @@public_directory ||= File.expand_path(File.basename(__FILE__) + "/public")
  end

  # Rack's call method. Will be called with the env, from rack. If it matches
  # a regular expression, it will start a new instance of the propiertary class.
  # If there's no matching class, it will return a 404.
  #
  # @param [Hash] env the rack's env.
  # @return [Array] the rack response.
  def self.call(env)
    @url_match = nil
    match_regex = @@candies.keys.find do |regex|
      @url_match = env['PATH_INFO'].match(regex)
    end
    unless match_regex
      if File.exists? public_directory + env['PATH_INFO']
        file = public_directory + env['PATH_INFO']
        content_type = Rack::Mime.mime_type(File.extname(file))
        return [200, {"Content-Type" => content_type}, [File.read(file)]]
      else
        return [404, {"Content-Type" => "text/html", "X-Cascade" => "pass"}, ["Not Found"]]
      end
    end
    candy = @@candies[match_regex].new(env, @url_match.to_a)
    candy.bite
  end
end

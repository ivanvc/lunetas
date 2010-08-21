require 'lunetas'

class Testing
  include Lunetas::Candy
  matches '/hello/(\w+)', :name

  def before
    @name = @name.capitalize
  end

  def get
    "Hello #{@name}! #{params[:chunky]}"
  end

  def post
    "Hey #{@name}, I see you're testing the POST method :)"
  end
end

class AnotherTest
  include Lunetas::Candy
  matches '^/(\d+)$', :number

  def get
    "Is #{@number} your lucky number?"
  end

  def other_verb(verb)
    if verb == 'TEAPOT'
      "I ain't a teapot!"
    end
  end
end

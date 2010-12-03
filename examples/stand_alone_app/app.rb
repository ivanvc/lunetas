require 'lunetas'

class App
  include Lunetas::Candy
  matches '/(\w+)$', :path

  def get
    @message = "So, were you looking for #{@path}?"
    erb :index
  end
end


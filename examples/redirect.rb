require '../lib/lunetas'

class Redirect
  include Lunetas::Candy
  matches '/'

  def get
    redirect 'http://google.com'
  end
end

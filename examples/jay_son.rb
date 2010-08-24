require 'lunetas'
require 'json'

class JaySon
  include Lunetas::Candy
  matches '^/something\.json$'
  set_content_type 'application/json'

  def get
    { :test => true, 'json' => "Yes, JSON", :amount => 1}.to_json
  end
end

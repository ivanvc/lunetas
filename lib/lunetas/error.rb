module ApiV1::Error
  class BaseError < StandardError
    def to_json
      {'error' => message}.to_json
    end 
    def code
      400 
    end 
    def message
      "Error"
    end 
  end 
  class AuthenticationError < BaseError
    def code
      401 
    end 
    def message
      "Permission denied"
    end 
  end 

  class BuildError < BaseError
    def code
      405 
    end 
    def message
      "Build error"
    end 
  end 

  class APIError < BaseError
    def code
      404 
    end 
    def message
      "API route error"
    end 
  end 
end

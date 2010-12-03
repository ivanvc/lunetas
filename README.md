![Lunetas](http://dulcemexico.com/productos/lunetasgrand.jpg)

Lunetas
=======

A Rack based micro framework. 

Structure
---------

It is a class-url based framework. It means, that every class describes a route using
a Regular Expression. It may respond to one or many HTTP methods. These responses are
defined overwritting the methods get, put, post, delete, trace, head, etc.. It can
also handle other non-native HTTP methods, using overwritting other_verb.

What does all these means? Checkout an example. (You can also take a look at the
examples folder).

Usage
-----

If you are going to use Lunetas as a stand alone Rack application. In order to get it
running, you just need to add `run Lunetas::Bag` in your config.ru file. 

If you are going to use Lunetas behind a framework like Rails. You just need to add
the gem, `require 'lunetas'` in your metal, and you are ready to go.

Now with support for public assets, and templates. Check out the example under
/examples/stand_alone_app, to see how it works!

Examples
--------

### Simple example

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

### Defining a custom ContentType

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

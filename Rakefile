require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lunetas"
    gem.summary = %Q{Rack micro framework intended for APIs}
    gem.description = %Q{This is a micro framework based in Rack, inspired in Sinatra, camping and many others. The intention is to have fast responses for simple API calls. The base unit of this framework are the classes, which registers a regular expression that will match this resource.}
    gem.email = "iv@nvald.es"
    gem.homepage = "http://github.com/ivanvc/lunetas"
    gem.authors = ["Iván Valdés (@ivanvc)"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"
    gem.add_development_dependency "shotgun", ">= 0"
    gem.add_dependency "rack", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  spec.pattern = 'spec/**/*_spec.rb'
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

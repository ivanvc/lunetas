module Lunetas::Candy::TemplateParsing
  module InstanceMethods
    # Parses the given file, located in templates/[template_name].erb.
    # @param filename the file located in the templates directory.
    # @return [String] the erb parsed template.
    def erb(filename)
      file = File.expand_path(File.basename(__FILE__) + '/templates/' +filename)
      ERB.new(file).result
    end
  end
end

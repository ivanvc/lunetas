module Lunetas::Candy::TemplateParsing
  module InstanceMethods
    # Parses the given file, located in templates/[template_name].erb.
    # @param filename the file located in the templates directory.
    # @return [String] the erb parsed template.
    def erb(filename)
      file = File.expand_path("templates/#{filename}.erb")
      ERB.new(File.read(file)).result(get_binding)
    end

    private
      # @private
      def get_binding
        binding
      end
  end
end

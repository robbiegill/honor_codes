require 'thor/group'
require 'yaml'

module HonorCodes
  module Generators
    class Template < Thor::Group
      include Thor::Actions

      argument :properties, :type => :array
      def write_template
        create_file 'license_template.yml', HonorCodes.make_template(properties)
      end
    end
  end
end
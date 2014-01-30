require 'thor'
require 'pp'
require 'honor_codes'
require 'honor_codes/generators/template'

module HonorCodes
  class CLI < Thor
    package_name 'HonorCodes'

    desc 'generate_from LICENSE_TEMPLATE [options]', 'generate license from LICENSE_TEMPLATE'
    long_desc <<-LONGDESC
Generates a simple license from a supplied yaml file. The resulting license will be dumped
into the same directory as the LICENSE_TEMPLATE.
    LONGDESC
    method_option :filename, :default => HonorCodes::LICENSE_NAME, :aliases => '-f', :desc => 'sets the output filename'
    method_option :print, :type => :boolean, :lazy_default => true, :aliases => '-p', :desc => 'prints the interpreted license'
    def generate_from(template_path)
      license_path = HonorCodes.generate template_path, options[:filename]
      puts %Q(License stored to: #{license_path})
      puts inspect license_path if options[:print]
    end

    desc 'inspect LICENSE_FILE', 'inspect LICENSE_FILE'
    long_desc <<-LONGDESC
Pretty prints the contents of the license.
    LONGDESC
    def inspect(license_path=HonorCodes::LICENSE_NAME)
      puts HonorCodes.interpret license_path
    end

    desc 'template [option ...]', 'generate a license template.yml'
    long_desc <<-LONGDESC
Generate a license_template.yml file by providing space separated options

option: key[:value[:type]] #types include int, date. If no type is supplied, the value will be a string

Example:
  honor_code template users:100:int vendor:my_company expires:2015-12-31:date
    LONGDESC
    def template(*fields)
      HonorCodes::Generators::Template.start fields
    end
  end
end

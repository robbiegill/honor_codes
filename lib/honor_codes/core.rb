require 'pathname'
require 'yaml'
require 'base64'

module HonorCodes
  LICENSE_NAME = 'honor_code.license'

  def self.generate(template_path, filename)
    Generator.new(template_path, filename).generate
  end

  def self.interpret(license_path)
    Interpreter.new(license_path).interpret
  end

  def self.make_template(props)
    TemplateMaker.new(props).make_template
  end

  class Generator
    attr_accessor :template_path, :filename

    def initialize(template_path, filename)
      self.template_path = template_path
      self.filename = filename
    end

    def generate
      template = Pathname.new(template_path)
      license = template.dirname.join(filename)
      license.open('w') do |file|
        file << Base64.encode64(template.read)
      end
      license.to_s
    end
  end

  class Interpreter
    attr_accessor :license_path

    def initialize(license_path)
      self.license_path = license_path
    end

    def interpret
      license = Pathname.new license_path
      YAML.load Base64.decode64(license.read)
    end
  end

  class TemplateMaker
    attr_accessor :props

    def initialize(props)
      self.props = props
    end

    def make_template
      content = props.inject({}) do |memo, prop|
        key, default, type = prop.split ':'
        memo[key] = convert_type default, type
        memo
      end
      YAML.dump :license => content
    end

    private

    def convert_type(val, type)
      case type
        when /(int|integer)/
          Integer(val)
        when /(date)/
          Date.parse(val)
        else
          val
      end
    end
  end
end
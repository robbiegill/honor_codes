require 'spec_helper'
require 'honor_codes'

describe HonorCodes do
  let(:license_template_dir) { Pathname.new '/tmp/spec/honor_codes' }
  let(:license_template_path) { Pathname.new '/tmp/spec/honor_codes/license_template.yml' }
  let(:license_template_content) do
    <<-EOF
top_level:
  fixnum_key: #{fixnum_key}
  date_key: #{date_key}
  last_key: #{last_key}
    EOF
  end
  let(:license_filename) { 'custom.file' }
  let(:generated_license_pathname) { license_template_dir.join(license_filename) }

  let(:fixnum_key) { 5 }
  let(:date_key) { '2014-12-31' }
  let(:last_key) { 'last_value' }

  before do
    FileUtils.rm_rf(license_template_dir)
    FileUtils.mkdir_p(license_template_dir)
    license_template_path.open('w') { |file| file << license_template_content }
  end

  describe '.generate' do
    context 'when passed a yml file and output filename' do
      before do
        described_class.generate license_template_path.to_s, license_filename
      end

      it %Q{creates a #{HonorCodes::LICENSE_NAME} file in the same directory} do
        expect(generated_license_pathname).to exist
      end

      it 'does not write pure yaml' do
        license_content = generated_license_pathname.read
        expect(YAML.load license_content).not_to eq(YAML.load license_template_content)
      end
    end
  end

  describe '.interpret' do
    let(:result) { described_class.interpret generated_license_pathname.to_s }

    before do
      described_class.generate license_template_path.to_s, license_filename
    end

    context 'when passed a honor_code.license file' do
      it 'reads the content into a license object with ruby types' do
        expect(result).to eq(YAML.load license_template_content)
        top_level = result['top_level']
        expect(top_level['fixnum_key']).to be_a(Fixnum)
        expect(top_level['last_key']).to eq(last_key)
        expect(top_level['date_key']).to eq(Date.parse date_key)
      end
    end
  end

  describe '.make_template' do
    let(:props) { %w( some_key:some_value other_key:100 ) }
    let(:content) { described_class.make_template props }
    let(:license_hash) { {'some_key' => 'some_value', 'other_key' => '100'} }
    let(:expected) do
      YAML.dump({:license => license_hash})
    end

    it 'splits elements on : and dumps yaml of the hash nested under :license' do
      expect(content).to eq(expected)
    end

    context 'with data types' do
      let(:props) { %w( int_key:1:integer string_key_type:val:string key_default_type:13 date_key:2014-12-31:date ) }
      let(:license_hash) { {'int_key' => 1, 'string_key_type' => 'val', 'key_default_type' => '13', 'date_key' => Date.parse('2014-12-31')} }

      it 'casts to the correct types in the yaml' do
        expect(content).to eq(expected)
      end

      context 'loading the produced template' do
        it 'is read with the same data types' do
          read_license = YAML.load(content)[:license]
          expect(read_license).to eq(license_hash)
          expect(read_license['key_default_type']).to be_a(String)
          expect(read_license['int_key']).to be_a(Fixnum)
          expect(read_license['string_key_type']).to be_a(String)
          expect(read_license['date_key']).to be_a(Date)
        end
      end
    end
  end
end
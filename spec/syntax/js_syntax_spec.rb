require 'spec_helper'
require 'jshintrb'

describe 'javascript syntax' do
  JS_HINT_OPTIONS = {
    bitwise: true,
    curly: true,
    eqeqeq: true,
    forin: true,
    immed: true,
    latedef: true,
    newcap: true,
    noarg: true,
    noempty: true,
    nonew: true,
    plusplus: true,
    regexp: true,
    undef: false,
    strict: false,
    trailing: true,
    browser: true
  }

  def find_by_reason(results, reason)
    results.detect do |result|
      result['reason'] == reason
    end.to_a
  end

  Dir.glob('app/**/*.js').each do |file|
    describe "format for #{file}" do
      let(:contents) { File.read(file) }
      let(:results) { Jshintrb.lint(contents, JS_HINT_OPTIONS) }

      it 'has no missing semicolons' do
        expect(find_by_reason(results, 'Missing semicolon.')).to eq []
      end

      it 'has no unnecessary semicolons' do
        expect(find_by_reason(results, 'Unnecessary semicolon.')).to eq []
      end
    end
  end
end

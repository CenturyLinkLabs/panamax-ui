require 'spec_helper'

describe VolumeHelper do
  describe '#optional_directory' do

    describe 'when the parameter is empty' do

      it 'returns a span tag with class note' do
        result = optional_directory('')
        expect(result).to include("<span class=\"note\">")
      end

      it 'set value to  Undefined by default' do
        result = optional_directory('')
        expect(result).to include('Undefined')
      end

      it 'uses default value when provided' do
        result = optional_directory('', 'NOT')
        expect(result).to include('NOT')
      end
    end

    describe 'when a parameter is provided' do

      it 'returns a strong tag with path value' do
        result = optional_directory('my_path')
        expect(result).to include('<strong>my_path</strong>')
      end
    end

  end
end

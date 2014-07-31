require 'spec_helper'

describe Repository do

  it { should respond_to :id }

  describe '#image_tags' do
    it 'should always respond to each' do
      expect(subject.image_tags).to respond_to :each
    end
  end
end

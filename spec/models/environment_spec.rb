require 'spec_helper'

describe Environment do
  describe '#requires_value?' do
    it 'returns true if the value is both required and blank' do
      subject.required = true
      expect(subject.requires_value?).to be_true
    end

    it 'returns false if the value is required, but filled in' do
      subject.required = true
      subject.value = 'present'
      expect(subject.requires_value?).to be_false
    end

    it 'returns false if the value is not required' do
      subject.required = false
      expect(subject.requires_value?).to be_false
    end
  end
end

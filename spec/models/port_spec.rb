require 'spec_helper'

describe Port do

  it { should respond_to :host_interface }
  it { should respond_to :host_port }
  it { should respond_to :container_port }
  it { should respond_to :proto }

  describe '#proto' do
    it 'defaults to TCP when blank' do
      expect(subject.proto).to eq 'TCP'
    end

    it 'is whatever is set when present' do
      subject.proto = 'UDP'
      expect(subject.proto).to eq 'UDP'
    end
  end
end

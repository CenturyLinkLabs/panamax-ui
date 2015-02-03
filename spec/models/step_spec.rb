require 'spec_helper'

describe Step do
  it_behaves_like 'an active resource model'

  it { should respond_to :id }
  it { should respond_to :order }
  it { should respond_to :name }
  it { should respond_to :source }

  describe '#get_status' do

    context 'when the order of the current step is 2' do
      before do
        subject.order = 2
      end

      it 'returns error when job status is error' do
        results = [nil, 0, 1, 2, 3].map do |steps|
          subject.get_status(steps, 'error')
        end
        expect(results).to eq 5.times.map { 'error' }
      end

      it 'returns waiting when nil steps have been completed' do
        expect(subject.get_status(nil, nil)).to eq 'waiting'
      end

      it 'returns waiting when 0 steps have been completed' do
        expect(subject.get_status(0, nil)).to eq 'waiting'
      end

      it 'returns in-progress when one step has been completed' do
        expect(subject.get_status(1, nil)).to eq 'in-progress'
      end

      it 'returns complete when two steps have been completed' do
        expect(subject.get_status(2, nil)).to eq 'complete'
      end

      it 'returns complete when more than two steps have been completed' do
        expect(subject.get_status(4, nil)).to eq 'complete'
      end
    end
  end
end

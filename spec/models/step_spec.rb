require 'spec_helper'

describe Step do
  it_behaves_like 'an active resource model'

  it { should respond_to :id }
  it { should respond_to :order }
  it { should respond_to :name }
  it { should respond_to :source }

  describe '#update_status!' do

    context 'when the order of the current step is 2' do
      before do
        subject.order = 2
      end

      context 'when the job is in the error state' do
        it 'returns complete when two steps have been completed' do
          subject.update_status!(2, 'error')
          expect(subject.status).to eq 'complete'
        end

        it 'returns complete when more than two steps have been completed' do
          subject.update_status!(4, 'error')
          expect(subject.status).to eq 'complete'
        end

        it 'returns error for the step in progress' do
          subject.update_status!(1, 'error')
          expect(subject.status).to eq 'error'
        end

        it 'returns nothing for steps that have not started' do
          subject.update_status!(0, 'error')
          expect(subject.status).to eq ''
        end
      end

      it 'returns waiting when nil steps have been completed' do
        subject.update_status!(nil, nil)
        expect(subject.status).to eq 'waiting'
      end

      it 'returns waiting when 0 steps have been completed' do
        subject.update_status!(0, nil)
        expect(subject.status).to eq 'waiting'
      end

      it 'returns in-progress when one step has been completed' do
        subject.update_status!(1, nil)
        expect(subject.status).to eq 'in-progress'
      end

      it 'returns complete when two steps have been completed' do
        subject.update_status!(2, nil)
        expect(subject.status).to eq 'complete'
      end

      it 'returns complete when more than two steps have been completed' do
        subject.update_status!(4, nil)
        expect(subject.status).to eq 'complete'
      end
    end
  end
end

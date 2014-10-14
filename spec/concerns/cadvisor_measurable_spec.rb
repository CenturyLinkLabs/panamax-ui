require 'spec_helper'

shared_examples_for "cadvisor_measurable" do
  before do
    MachineInfo.stub(:find).and_return(MachineInfo.new({ num_cores: 2, memory_capacity: 1000 }))
  end

  let(:attributes) do
    {
        stats: [
            {
                cpu: {
                    usage: {
                        total: 0,
                        per_cpu_usage: [100]
                    }
                },
                memory: {
                    usage: 1024
                },
                timestamp: '2014-10-14T17:43:45.818251017Z'
            },
            {
                cpu: {
                    usage: {
                        total: 10000000,
                        per_cpu_usage: [100]
                    }
                },
                memory: {
                    usage: 1024
                },
                timestamp: '2014-10-14T18:43:45.818251017Z'
            }
        ],
        spec: {
            has_cpu: true,
            has_memory: true,
            memory: {
                limit: 2000
            },
            cpu: {
                limit: 100
            }
        }
    }
  end

  let(:overall) do
    {
        'usage' => 0,
        'percent' => 0
    }
  end

  let(:overall_mem) do
    {
        'usage' => 1024,
        'percent' => 102
    }
  end

  subject { described_class.new(attributes) }

  describe '#overall' do
    it 'returns overall_mem result' do
      expect(subject.overall.overall_mem).to eq overall_mem
    end

    it 'returns overall_cpu result' do
      expect(subject.overall.overall_cpu).to eq overall
    end
  end
end

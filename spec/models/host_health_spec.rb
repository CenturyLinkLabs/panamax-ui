require 'spec_helper'

describe HostHealth do

  let(:attributes) do
    {
      stats: [
        {
          cpu: {
            usage: {
              total: 0,
              per_cpu: [100]
            }
          },
          memory: {
            usage: 1024
          }
        },
        {
          cpu: {
            usage: {
              total: 10000000,
              per_cpu: [100]
            }
          },
          memory: {
            usage: 1024
          }
        }
      ],
      spec: {
        memory: {
          limit: 100
        },
        cpu: {
          limit: 100
        }
      }
    }
  end

  let(:overall) do
    {
      'usage' => 0.01,
      'percent' => 1.0
    }
  end

  let(:overall_mem) do
    {
      'usage' => 1024,
      'percent' => 1024
    }
  end

  subject { described_class.new(attributes) }

  it { should respond_to :overall }

  describe '#overall' do
    it 'returns overall_mem result' do
      expect(subject.overall.overall_mem).to eq overall_mem
    end

    it 'returns overall_cpu result' do
      expect(subject.overall.overall_cpu).to eq overall
    end
  end

  describe '.singleton_path' do
    it 'returns /api/v1.0/containers/' do
      expect(HostHealth.singleton_path).to eq '/api/v1.0/containers/'
    end

  end
end

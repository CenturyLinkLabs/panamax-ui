require 'spec_helper'

describe HostHealth do
  it_behaves_like 'cadvisor_measurable'

  describe '.singleton_path' do
    it 'returns /api/v1.2/containers/' do
      expect(HostHealth.singleton_path).to eq '/api/v1.2/containers/'
    end
  end
end

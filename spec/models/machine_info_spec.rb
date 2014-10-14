require 'spec_helper'

describe MachineInfo do

  it_behaves_like 'an active resource model'

  describe '.singleton_path' do
    it 'returns /api/v1.0/machine' do
      expect(MachineInfo.singleton_path).to eq '/api/v1.0/machine'
    end
  end
end

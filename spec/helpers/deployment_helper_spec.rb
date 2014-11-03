require 'spec_helper'

describe DeploymentHelper do
  describe '#deployment_count_options' do
    it 'returns a nested array of options up to 9' do
      expected = [1,2,3,4,5,6]
      expect(helper.deployment_count_options).to eq expected
    end
  end
end

require 'spec_helper'

describe DeploymentHelper do
  describe '#deployment_count_options' do
    it 'returns a nested array of options up to 9' do
      expected = [1,2,3,4,5,6]
      expect(helper.deployment_count_options).to eq expected
    end
  end

  describe '#provider_label' do

    it 'returns the provider image when present' do
      img_path = 'providers/logo_existing_image_small.png'
      allow(File).to receive(:exist?)
        .with(Rails.root.join('app', 'assets', 'images', img_path))
        .and_return(true)
      label = provider_label('Existing Image')
      expect(label).to eq image_tag(img_path, alt: 'Existing Image')
    end

    it 'returns the provider name when image is not present' do
      label = provider_label('No Image')
      expect(label).to eq 'No Image'
    end
  end
end

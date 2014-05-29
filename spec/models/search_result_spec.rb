require 'spec_helper'

describe SearchResultSet do

  let(:attributes) do
    {
      'q' => 'bla',
      'local_images' => [
        {'name' => 'Wordpress'},
        {'name' => 'MYSQL'}
      ],
      'remote_images' => [
        {'name' => 'Drupal'},
        {'name' => 'Postgres'}
      ],
      'templates' => [
        {'name' => 'Rails'},
        {'name' => 'Django'}
      ]
    }
  end

  it_behaves_like 'a view model', {
    'remote_images' => [],
    'local_images' => [],
    'templates' => []
  }

  describe '.build_from_response' do
    subject { SearchResultSet }

    let(:fake_json_response) { attributes.to_json }

    it 'instatiates itself with the parsed json attributes' do
      result = subject.build_from_response(fake_json_response)

      expect(result).to be_a SearchResultSet
      expect(result.query).to eql 'bla'
    end

    it 'instantiates a local image for each nested local image' do
      result = described_class.build_from_response(fake_json_response)
      expected = [
        Image.new(name: 'Wordpress', location: :local),
        Image.new(name: 'MYSQL', location: :local)
      ]
      expect(result.local_images).to match_array(expected)
    end

    it 'instantiates a remote image for each nested remote image' do
      result = described_class.build_from_response(fake_json_response)
      expected = [
        Image.new(name: 'Drupal', location: :remote),
        Image.new(name: 'Postgres', location: :remote)
      ]
      expect(result.remote_images).to match_array(expected)
    end

    it 'instantiates a template for each nested template' do
      result = described_class.build_from_response(fake_json_response)
      expected = [
        Template.new(name: 'Rails'),
        Template.new(name: 'Django')
      ]
      expect(result.templates).to match_array(expected)
    end

    it 'does not blow up if remote images is not defined' do
      without_remote_images = attributes.except('remote_images').to_json
      expect {
        subject.build_from_response(without_remote_images)
      }.to_not raise_error
    end

    it 'does not blow up if local images is not defined' do
      without_local_images = attributes.except('local_images').to_json
      expect do
        subject.build_from_response(without_local_images)
      end.to_not raise_error
    end

    it 'does not blow up if templates is not defined' do
      without_templates = attributes.except('templates').to_json
      expect do
        subject.build_from_response(without_templates)
      end.to_not raise_error
    end
  end

  describe '#as_json' do
    subject { SearchResultSet.new(attributes) }

    it 'provides the attributes to be converted to JSON' do
      result = subject.as_json

      query = attributes.delete('q')
      expected = attributes.merge({'query' => query})
      expect(result).to eq expected
    end
  end
end

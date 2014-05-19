require 'spec_helper'

describe App do
  let(:attributes) do
    {
      'name' => 'App Daddy',
      'id' => 77,
      'categories' => [
          {'id' => '1', 'name' => 'foo'},
          {'id' => '2', 'name' => 'baz'},
          {'id' => '3', 'name' => 'bar'}
      ],
      'services' => [
          {'id' => '3', 'name' => 'blah', 'categories' => [ {'name' => 'foo'}, {'name' => 'baz'}]},
          {'id' => '4', 'name' => 'barf', 'categories' => [ {'name' => 'foo'} ]},
          {'id' => '5', 'name' => 'bark', 'categories' => [ {'name' => 'bar'} ]},
          {'id' => '6', 'name' => 'bard', 'categories' => []}
      ]
    }
  end

  it_behaves_like 'a view model', {
    'name' => 'App Daddy',
    'id' => 77,
    'categories' => [],
    'services' => []
  }

  let(:fake_json_response) { attributes.to_json }

  describe '.build_from_response' do

    it 'instantiates itself with the parsed json attributes' do
      result = described_class.build_from_response(fake_json_response)
      expect(result).to be_an App
      expect(result.name).to eq 'App Daddy'
      expect(result.id).to eq 77
    end

    it 'instantiates a Service for each nested service' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.services.map(&:name)).to match_array(['blah', 'barf', 'bark', 'bard'])
      expect(result.services.map(&:class).uniq).to match_array([Service])
    end

    it 'instantiates an AppCategory for each nested category' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.categories.map(&:name)).to match_array(['foo','baz','bar'])
    end
  end

  describe '#valid?' do
    context 'when errors are empty' do
      it 'is valid' do
        expect(subject.valid?).to be_true
      end
    end

    context 'when errors are present' do
      subject { described_class.new('errors' => {'base' => ['you messed up']}) }

      it 'is not valid' do
        expect(subject.valid?).to be_false
      end
    end
  end

  describe '#to_param' do
    subject { described_class.new('id' => 77) }

    it 'returns the id' do
      expect(subject.to_param).to eq 77
    end
  end

  describe '#as_json' do
    subject { App.new(attributes) }

    it 'provides the attributes to be converted to JSON' do
      expected = attributes
      expect(subject.as_json).to eq expected
    end
  end

  describe '#host_ports' do
    subject { described_class.build_from_response(fake_json_response) }
    it 'returns a hash' do
      expect(subject.host_ports).to be_a Hash
    end

    it 'returns a hash with keys matching the names of services with port bindings' do
      expect(subject.host_ports.keys).to match_array ["blah"]
    end

    it 'returns a hash with values containing an array of bound host ports for services with port bindings' do
      expect(subject.host_ports.values).to match_array [[8080]]
    end
  end

  describe '#running_services' do
    it 'returns an array of running services' do
      app = described_class.build_from_response(fake_json_response)
      expect(app.running_services.map(&:id)).to match_array ["3"]
    end
  end

  context 'when dealing with application categories' do
    subject { described_class.build_from_response(fake_json_response) }

    describe '#categorized_services' do
      it 'returns a hash of services grouped by category' do
        groups = subject.categorized_services
        expect(groups.keys).to include({:id => '1', :name => 'foo'},
                                       {:id => '2', :name => 'baz'},
                                       {:id => '3', :name => 'bar'})
        expect(groups.values.flatten.map { |s| s.name }).to include('blah', 'barf', 'bark')
      end

      it 'includes an Uncategorized service group if there are categorized and uncategorized services' do
        groups = subject.categorized_services
        expect(groups.keys).to include({:id => nil, :name => 'Uncategorized'})
      end

      it 'does not include Uncategorized service group if there are only categorized services' do
        subject.services.delete_if { |service| service.categories.empty? }
        groups = subject.categorized_services
        expect(groups.keys).to_not include({:id => nil, :name => 'Uncategorized'})
      end

      it 'groups all services under a "Services" group if there are no categories' do
        attributes['services'].each { |s| s['categories'] = [] }
        attributes['categories'] = []
        groups = subject.categorized_services
        expect(groups.keys).to match_array([{:id => nil, :name => 'Services'}])
      end
    end

    describe '#services_with_category_name' do
      it 'returns services for a specified category name' do
        services = subject.services_with_category_name('foo')
        expect(services.map { |s| s.name }).to include('blah', 'barf')
        expect(services.map { |s| s.name }).to_not include('bark')
      end

      it 'returns an empty array if the category name is not present' do
        services = subject.services_with_category_name('notaname')
        expect(services).to eq []
      end
    end

    describe '#uncategorized_services' do
      it 'returns an array of services that have no categories' do
        subject.uncategorized_services.each do |service|
          expect(service.categories).to eq []
        end
      end
    end
  end
end

require 'spec_helper'

describe App do
  let(:attributes) do
    {
      'name' => 'App Daddy',
      'id' => 77,
      "services" => [
          {'name' => 'blah', 'categories' => [ {'name' => 'foo'}, {'name' => 'baz'}]},
          {'name' => 'barf', 'categories' => [ {'name' => 'foo'} ]},
          {'name' => 'bark', 'categories' => [ {'name' => 'bar'} ]},
          {'name' => 'bard', 'categories' => []}
      ]
    }
  end

  it_behaves_like 'a view model'

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

  context 'when dealing with service categories' do
    subject { described_class.build_from_response(fake_json_response) }

    describe '#service_categories' do
      it 'returns the union of all service categories for the app services' do
        categories = subject.service_categories
        expect(categories.collect{|c| c.name}).to include('foo', 'baz', 'bar')
      end

      it 'returns a list of unique service categories' do
        categories = subject.service_categories.find_all{|c| c.name == 'foo'}
        expect(categories).to have_at_most(1).item
      end
    end

    describe '#categorized_services' do
      it 'returns a hash of services grouped by category name' do
        groups = subject.categorized_services
        expect(groups.keys).to include('foo', 'baz', 'bar')
        expect(groups.values.flatten.map { |s| s.name }).to include('blah', 'barf', 'bark')
      end

      it 'includes an Uncategorized service group if there are categorized and uncategorized services' do
        groups = subject.categorized_services
        expect(groups.keys).to include('Uncategorized')
      end

      it 'does not include Uncategorized service group if there are only categorized services' do
        attributes['services'].delete({'name' => 'bard', 'categories' => []})
        groups = subject.categorized_services
        expect(groups.keys).to_not include('Uncategorized')
      end

      it 'groups all services under a "Service" group if there are only uncategorized services' do
        attributes['services'].each { |s| s['categories'] = [] }
        groups = subject.categorized_services
        expect(groups.keys).to match_array(['Services'])
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

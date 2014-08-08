require 'spec_helper'

describe App do
  let(:attributes) do
    {
      'name' => 'App Daddy',
      'id' => 77,
      'categories' => [
        { 'id' => '1', 'name' => 'foo' },
        { 'id' => '2', 'name' => 'baz' },
        { 'id' => '3', 'name' => 'bar' }
      ],
      'from' => 'nowhere',
      'documentation' => '# Title\r\nsome markdown doc',
      'services' => [
        { 'id' => '3', 'name' => 'blah', 'sub_state' => 'running', 'ports' => [{host_port: 8080}], 'categories' =>
          [{ 'name' => 'foo', 'id' => 3, 'position' => 3  }, { 'name' => 'baz', 'id' => 3 }] },
        { 'id' => '4', 'name' => 'barf', 'categories' => [{ 'name' => 'foo', 'id' => 2, 'position' => 2 }] },
        { 'id' => '5', 'name' => 'bark', 'categories' => [{ 'name' => 'bar', 'id' => 1, 'position' => 1 }] },
        { 'id' => '6', 'name' => 'bard', 'categories' => [] }
      ]
    }
  end

  it_behaves_like 'an active resource model'

  it { should respond_to :services }
  it { should respond_to :template_id }

  describe '#to_param' do
    subject { described_class.new('id' => 77) }

    it 'returns the id' do
      expect(subject.to_param).to eq 77
    end
  end

  describe '#has_empty_env_values?' do
    it 'returns true if any of the services have an empty env value' do
      fake_service = double(:fake_service, has_empty_env_values?: true)
      subject.services = [fake_service]
      expect(subject.has_empty_env_values?).to be_true
    end

    it 'returns false if there are no services' do
      subject.services = []
      expect(subject.has_empty_env_values?).to be_false
    end

    it 'returns false if none of the services have empty env values' do
      fake_service = double(:fake_service, has_empty_env_values?: false)
      subject.services = [fake_service]
      expect(subject.has_empty_env_values?).to be_false
    end
  end

  describe '#documentation_to_html' do
    it 'attempts to parse the #documentation as markdown' do
      app = described_class.new(attributes)
      expect(Kramdown::Document).to receive(:new).with(app.documentation).and_return(double(to_html: true))
      app.documentation_to_html
    end
  end

  context 'when dealing with application categories' do
    subject { described_class.new(attributes) }

    describe '#categorized_services' do
      it 'returns a hash of services grouped by category' do
        groups = subject.categorized_services
        expect(groups.keys.map(&:id)).to include('1', '2', '3')
        expect(groups.values.flatten.map { |s| s.name }).to include('blah', 'barf', 'bark')
      end

      it 'includes an Uncategorized service group if there are categorized and uncategorized services' do
        groups = subject.categorized_services
        expect(groups.keys.map(&:name)).to include('Uncategorized')
      end

      it 'does not include Uncategorized service group if there are only categorized services' do
        subject.services.delete_if { |service| service.categories.empty? }
        groups = subject.categorized_services
        expect(groups.keys).to_not include(id: nil, name: 'Uncategorized')
      end

      it 'groups all services under a "Uncategorized" group if there are no categories' do
        attributes['services'].each { |s| s['categories'] = [] }
        attributes['categories'] = []
        groups = subject.categorized_services
        expect(groups.keys.map(&:name)).to match_array(['Uncategorized'])
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

    describe '#ordered_services' do
      it 'returns an array of services in minimum category order' do
        services = subject.ordered_services
        expect(services.map { |s| s.name }).to match_array(%w(bark barf blah bard))
      end
    end
  end
end

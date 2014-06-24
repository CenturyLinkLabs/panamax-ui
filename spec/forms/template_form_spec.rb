require 'spec_helper'

describe TemplateForm do

  let(:attributes) do
    {
      name: 'My template',
      description: 'generic wordpress installation',
      keywords: 'fast, simple, elegant',
      icon: 'http://icons.com/icon.png'
    }
  end

  subject { described_class.new(attributes) }

  it { should respond_to :repos }
  it { should respond_to :repos= }
  it { should respond_to :name }
  it { should respond_to :name= }
  it { should respond_to :keywords }
  it { should respond_to :keywords= }
  it { should respond_to :author= }

  describe '#author' do
    it 'defaults to the users email address' do
      subject.user = double(:fake_user, email: 'test@example.com')
      expect(subject.author).to eq 'test@example.com'
    end

    it 'is author if both user.email and author are set' do
      subject.user = double(:fake_user, email: 'test@example.com')
      subject.author = 'iwin@example.com'
      expect(subject.author).to eq 'iwin@example.com'
    end

    it 'is nil if user has no email address' do
      expect(subject.author).to be_nil
    end
  end

  describe '#icon' do
    it 'is the icon if set' do
      expect(subject.icon).to eq 'http://icons.com/icon.png'
    end

    it 'defaults to the value for Icon Blocks when icon is falsey' do
      subject.icon = nil
      expect(subject.icon).to eq 'http://panamax.ca.tier3.io/template_logos/default.png'
    end
  end

  describe '#save' do
    it 'creates a template' do
      expect(Template).to receive(:create).with(
        attributes.merge(authors: [nil])
      )
      subject.save
    end
  end

  describe '.icon_options' do
    it 'returns a hash' do
      expect(described_class.icon_options).to be_a Hash
    end
  end
end

require 'spec_helper'

describe TemplateForm do

  let(:attributes) do
    {
      name: 'My template',
      description: 'generic wordpress installation',
      keywords: 'fast, simple, elegant',
      type: 'wordpress',
      app_id: 7
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
  it { should respond_to :app_id }
  it { should respond_to :app_id= }

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

  describe '#type' do
    let(:fake_types) { double(:types) }

    subject { described_class.new(attributes.merge(types: fake_types)) }

    before do
      fake_types.stub(:first).and_return(double(:type, name: 'Generic'))
    end

    it 'is the type if set' do
      expect(subject.type).to eq 'wordpress'
    end

    it 'defaults to the value when type is falsey' do
      subject.type = nil
      expect(subject.type).to eq 'Generic'
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

end

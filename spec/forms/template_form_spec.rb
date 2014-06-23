require 'spec_helper'

describe TemplateForm do

  let(:attributes) do
    {
      name: 'My template',
      description: 'generic wordpress installation',
      keywords: 'fast, simple, elegant'
    }
  end

  subject { described_class.new(attributes) }

  it { should respond_to :repos }
  it { should respond_to :name }
  it { should respond_to :keywords }

  describe '#save' do

    it 'creates a template' do
      expect(Template).to receive(:create).with(attributes)
      subject.save
    end
  end
end

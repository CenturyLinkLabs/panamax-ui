require 'spec_helper'

describe TemplateForm do

  let(:attributes) do
    {
      name: 'My template',
      description: 'generic wordpress installation',
      keywords: 'fast, simple, elegant',
      type: 'wordpress',
      repo: 'some/repo',
      app_id: 7,
      documentation: '##some markdown##'
    }
  end

  subject { described_class.new(attributes) }

  it { should respond_to :repo }
  it { should respond_to :repo= }
  it { should respond_to :name }
  it { should respond_to :name= }
  it { should respond_to :keywords }
  it { should respond_to :keywords= }
  it { should respond_to :author= }
  it { should respond_to :app_id }
  it { should respond_to :app_id= }
  it { should respond_to :app= }
  it { should respond_to :app }
  it { should respond_to :documentation }
  it { should respond_to :documentation= }

  describe '#app_id' do
    it 'is app_id if set' do
      expect(subject.app_id).to eq 7
    end

    it 'is the apps id when app_id is nil' do
      subject.app = double(:fake_app, id: 6)
      subject.app_id = nil
      expect(subject.app_id).to eq 6
    end

    it 'returns nil if neither are set' do
      subject.app = nil
      subject.app_id = nil
      expect(subject.app_id).to be_nil
    end
  end

  describe '#documentation' do
    before do
      I18n.stub(:t).with('boilerplate_template_documentation').and_return('## default markdown ##')
    end

    it 'returns documentation if set' do
      expect(subject.documentation).to eq '##some markdown##'
    end

    it 'returns the apps documentation otherwise' do
      subject.documentation = nil
      subject.app = double(:fake_app, documentation: 'app doc')
      expect(subject.documentation).to eq 'app doc'
    end

    pending 'returns the default documentation if neither are set' do
      subject.documentation = nil
      subject.app = nil
      expect(subject.documentation).to eq '## default markdown ##'
    end

    context 'when the documentation contains carriage returns' do

      before do
        subject.documentation = "line1\r\nline2"
      end

      it 'strips the carriages returns out' do
        expect(subject.documentation).to eq "line1\nline2"
      end

    end

    context 'when the documentation cointains whitespace preceding a newline' do

      before do
        subject.documentation = "line1  \n\nline2 \r\nline3"
      end

      it 'strips out the non-newline whitespace' do
        expect(subject.documentation).to eq "line1\n\nline2\nline3"
      end
    end
  end

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

  # describe '#errors' do
  #   context 'when no template is present' do
  #     it 'returns no errors' do
  #       expect(subject.errors).to eq nil
  #     end
  #   end
  #
  #   context 'when a template is present' do
  #     let(:fake_template) { double(:fake_template, errors: 'some error', valid?: false) }
  #
  #     before do
  #       Template.stub(:create).and_return(fake_template)
  #       subject.save
  #     end
  #
  #     it 'returns the @template errors' do
  #       expect(subject.errors).to eq 'some error'
  #     end
  #   end
  # end

  describe '#save' do
    let(:fake_template) { double(:fake_template, valid?: true) }

    it 'creates a template' do
      expect(Template).to receive(:create).with(
        name: 'My template',
        description: 'generic wordpress installation',
        keywords: 'fast, simple, elegant',
        source: 'some/repo',
        authors: [nil],
        type: 'wordpress',
        app_id: 7,
        documentation: '##some markdown##'
      ).and_return(fake_template)
      subject.stub(:save_template_to_repo).and_return(true)
      subject.save
    end

    context 'when template creation is successful' do
      let(:fake_template) { double(:fake_template, valid?: true) }

      before do
        Template.stub(:create).and_return(fake_template)
      end

      it 'saves the template to the supplied repo' do
        expect(fake_template).to receive(:post).with(
          :save,
          repo: 'some/repo',
          file_name: 'my_template'
        )
        subject.save
      end
    end

    context 'when template creation is not successful' do
      let(:errors) { double(:errors, messages: { name: ['is invalid'] }) }
      let(:fake_template) { double(:fake_template, errors: errors, valid?: false) }

      before do
        Template.stub(:create).and_return(fake_template)
      end

      it 'does not save the template to a repo' do
        expect(Template.any_instance).to_not receive(:post)
        subject.save
      end

      it 'merges the template errors with the template form errors' do
        subject.save
        expect(subject.errors.messages).to include(name: ['is invalid'])
      end
    end
  end

end

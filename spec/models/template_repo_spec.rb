require 'spec_helper'

describe TemplateRepo do

  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :updated_at }
  it { should respond_to :created_at }

  describe '.find_or_create_by_name' do
    it 'adds repo if it does not exists' do
      expect(TemplateRepo).to receive(:create).with(name: 'foo/bar')
      described_class.find_or_create_by_name('foo/bar')
    end

    it 'does not add repo if repo already exists' do
      expect(TemplateRepo).to_not receive(:create).with(name: 'ctllabs/canonical')
      described_class.find_or_create_by_name('ctllabs/canonical')
    end
  end

  describe '.has_user_sources?' do
    context 'when template sources repo has an user repo' do
      before do
        allow(TemplateRepo).to receive_message_chain(:all, :count).and_return(3)
      end

      it 'returns true' do
        expect(TemplateRepo.has_user_sources?).to be_truthy
      end
    end

    context 'when template sources repo does not have an user repo' do
      before do
        allow(TemplateRepo).to receive_message_chain(:all, :count).and_return(2)
      end

      it 'returns false if ' do
        expect(TemplateRepo.has_user_sources?).to be_falsey
      end
    end
  end

end

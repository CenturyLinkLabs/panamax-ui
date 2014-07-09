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
      expect(TemplateRepo).to_not receive(:create).with(name: 'user/publicrepo')
      described_class.find_or_create_by_name('user/publicrepo')
    end
  end

end

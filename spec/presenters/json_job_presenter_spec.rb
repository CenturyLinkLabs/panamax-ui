require 'spec_helper'

describe JsonJobPresenter do

  let(:view_context) { ActionView::Base.new }

  subject(:presenter) { described_class.new(view_context) }

  describe '#title' do
    subject { presenter.title }

    it { should eq '{{key}}' }
  end

  describe '#status' do
    subject { presenter.status }

    it { should eq '{{status}}' }
  end

  describe '#steps' do
    it 'wraps the injected template with the handlebar tags' do
      result = subject.steps do |option_one, option_two|
        "NAME:#{option_one}STATUS:#{option_two}END"
      end
      expect(result).to eq('{{#each steps}}NAME:{{this.name}}STATUS:{{this.status}}END{{/each}}')
    end
  end
end

require 'spec_helper'

describe JobPresenter do

  let(:fake_job) do
    double(:fake_job,
           name: 'abc123',
           status: 'complete',
           steps: [
             double(:step1, name: 'foo', status: 'complete'),
             double(:step2, name: 'bar', status: 'in-progress')
           ]
    )
  end

  let(:view_context) { ActionView::Base.new }

  subject(:presenter) { described_class.new(fake_job, view_context) }

  describe '#title' do
    subject { presenter.title }

    it { should eq 'abc123' }
  end

  describe '#status' do
    subject { presenter.status }

    it { should eq 'complete' }
  end

  describe '#steps' do
    it 'returns the templatized representation' do
      result = subject.steps do |name, status|
        "NAME:#{name}|STATUS:#{status}"
      end
      expect(result).to eq("NAME:foo|STATUS:complete\nNAME:bar|STATUS:in-progress")
    end
  end

end

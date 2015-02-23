require 'spec_helper'

describe JobPresenter do

  let(:fake_job) do
    double(:fake_job,
           id: 7,
           key: 'xyz',
           name: 'abc123',
           status: 'complete',
           success?: nil,
           failure?: nil,
           template: '',
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

  describe '#documentation' do
    context 'when a template has been assigned to the job' do
      before do
        allow(fake_job).to receive(:template).and_return(double(:fake_template, documentation: '#bla'))
        allow(view_context).to receive(:markdown_to_html).with('#bla').and_return('<h1>bla</h1>')
      end

      its(:documentation) { should eq '<h1>bla</h1>' }
    end

    context 'when no template has been assigned to the job' do
      before do
        allow(view_context).to receive(:markdown_to_html).with(nil).and_return('')
      end

      its(:documentation) { should eq '' }
    end
  end

  describe '#destroy_path' do
    before do
      allow(view_context).to receive(:job_path).with('xyz').and_return('/destroy/path')
    end
    it 'returns the job_path' do
      expect(subject.destroy_path).to eq '/destroy/path'
    end
  end

  describe '#status' do
    subject { presenter.status }

    it { should eq 'complete' }
  end

  describe '#dom_id' do
    subject { presenter.dom_id }

    it { should eq 'job_7' }
  end

  describe '#message' do
    its(:message) { should be_nil }

    context 'when the job was successful' do
      before do
        allow(fake_job).to receive(:success?).and_return(true)
      end

      its(:message) { should eq I18n.t('jobs.completion.success') }
    end
    context 'when the job failed' do
      before do
        allow(fake_job).to receive(:failure?).and_return(true)
      end

      its(:message) { should eq I18n.t('jobs.completion.failure') }
    end
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

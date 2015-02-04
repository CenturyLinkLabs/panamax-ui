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

  describe '#destroy_path' do
    before do
      view_context.stub(:job_path).with('xyz').and_return('/destroy/path')
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
        fake_job.stub(:success?).and_return(true)
      end

      its(:message) { should eq I18n.t('jobs.completion.success') }
    end
    context 'when the job failed' do
      before do
        fake_job.stub(:failure?).and_return(true)
      end

      its(:message) { should eq I18n.t('jobs.completion.failure') }
    end
  end

  describe '#unless_running' do
    it 'returns nothing when running' do
      fake_job.stub(:running?).and_return(true)
      result = subject.unless_running { 'foo' }
      expect(result).to be_nil
    end

    it 'returns the html when not running' do
      fake_job.stub(:running?).and_return(false)
      result = subject.unless_running { 'foo' }
      expect(result).to eq 'foo'
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

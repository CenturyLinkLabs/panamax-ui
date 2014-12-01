require 'spec_helper'

describe JsonDeploymentPresenter do

  let(:fake_target) do
    double(:fake_target,
      id: 9,
      to_param: 9
    )
  end

  let(:view_context) { ActionView::Base.new }

  subject(:presenter) { described_class.new(fake_target, view_context) }

  describe '#deployment_name' do
    subject { presenter.deployment_name }

    it { should eq '{{display_name}}'}
  end

  describe '#deployment_id' do
    subject { presenter.deployment_id }

    it { should eq '{{id}}'}
  end

  describe '#dom_id' do
    subject { presenter.dom_id }

    it { should eq 'deployment_{{id}}' }
  end

  describe '#destroy_path' do
    subject { presenter.destroy_path }

    before do
      allow(view_context).to receive(:deployment_target_deployments_path).with(9).and_return('/foo/bar')
    end

    it { should eq '/foo/bar/{{id}}' }
  end

  describe '#redeploy_path' do
    subject { presenter.redeploy_path }

    before do
      view_context.stub(:deployment_target_deployments_path).with(9).and_return('/foo/bar')
    end

    it { should eq '/foo/bar/{{id}}/redeploy' }
  end

  describe '#service_count' do
    subject { presenter.service_count }

    it { should eq '{{status.services.length}}' }
  end

  describe '#services' do
    it 'wraps the injected template with the handlebar tags' do
      result = subject.services do |option_one, option_two|
        "TEMPLATE_STUFF#{option_one}TEMPLATE_STUFF#{option_two}TEMPLATE_STUFF"
      end
      expect(result).to eq('{{#each status.services}}TEMPLATE_STUFF{{this.id}}TEMPLATE_STUFF{{this.actualState}}TEMPLATE_STUFF{{/each}}')
    end
  end
end

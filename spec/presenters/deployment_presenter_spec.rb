require 'spec_helper'

describe DeploymentPresenter do

  let(:fake_deployment) do
    double(:fake_deployment,
      id: 7,
      display_name: 'wordpress',
      to_param: 7,
      service_ids: [1,2]
    )
  end

  let(:fake_target) do
    double(:fake_target,
      id: 9,
      to_param: 9
    )
  end

  let(:view_context) { ActionView::Base.new }

  subject(:presenter) { described_class.new(fake_target, fake_deployment, view_context) }

  describe '#deployment_name' do
    subject { presenter.deployment_name }

    it { should eq 'wordpress' }
  end

  describe '#deployment_id' do
    subject { presenter.deployment_id }

    it { should eq 7}
  end

  describe '#dom_id' do
    subject { presenter.dom_id }

    it { should eq 'deployment_7' }
  end

  describe '#destroy_path' do
    subject { presenter.destroy_path }

    before do
      view_context.stub(:deployment_target_deployment_path).with(9, 7).and_return('/foo/bar')
    end

    it { should eq '/foo/bar' }
  end

  describe '#service_count' do
    subject { presenter.service_count }

    it { should eq 2 }
  end

  describe '#services' do
    it 'returns the templatized representation' do
      result = subject.services do |id, status|
        "TEMPLATE_STUFF_#{id}_TEMPLATE_STUFF#{status}"
      end
      expect(result).to eq("TEMPLATE_STUFF_1_TEMPLATE_STUFF\nTEMPLATE_STUFF_2_TEMPLATE_STUFF")
    end
  end

end

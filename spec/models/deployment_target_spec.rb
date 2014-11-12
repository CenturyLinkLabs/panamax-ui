require 'spec_helper'

describe DeploymentTarget::Metadata do
  describe "#created_at" do
    let(:time) { Time.parse("2014-03-19") }
    let(:metadata) { DeploymentTarget::Metadata.new(created_at: time.to_json) }
    subject { metadata.created_at }

    it { should eq(time) }
  end
end

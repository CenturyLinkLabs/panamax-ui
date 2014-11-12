class DeploymentTargetMetadataRefresh < BaseResource
  include ActiveResource::Singleton

  self.site = PanamaxApi::URL + "/deployment_targets/:deployment_target_id/metadata"
  self.singleton_name = "refresh"

  belongs_to :deployment_target
end

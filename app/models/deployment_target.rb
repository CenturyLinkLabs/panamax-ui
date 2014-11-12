class DeploymentTarget < BaseResource

  schema do
    string :name
    string :auth_blob
    string :endpoint_url
  end

  class Metadata < BaseResource
    def created_at
      Time.parse(attributes[:created_at])
    end
  end
end

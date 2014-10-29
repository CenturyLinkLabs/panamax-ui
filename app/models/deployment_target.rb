class DeploymentTarget < BaseResource

  schema do
    string :name
    string :auth_blob
    string :endpoint_url
  end

end

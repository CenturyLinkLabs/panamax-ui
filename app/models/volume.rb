class Volume < BaseResource

  schema do
    string :host_path
    string :container_path
  end
end

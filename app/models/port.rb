class Port < BaseResource

  schema do
    string :host_interface
    integer :host_port
    integer :container_port
    string :proto
  end
end

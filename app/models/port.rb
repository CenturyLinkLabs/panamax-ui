class Port < BaseResource

  schema do
    string :host_interface
    integer :host_port
    integer :container_port
    string :proto
  end

  def proto
    @attributes['proto'].blank? ? 'TCP' : @attributes['proto']
  end
end

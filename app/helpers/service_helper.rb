module ServiceHelper
  def add_fields_for(name, f, options={}, &block)
    new_object = OpenStruct.new(persisted?: false)
    f.fields_for(name, new_object, options, &block)
  end

  def linkable_service_options(services, service_id)
    services.map do |service|
      [service.name, service.id] unless service.id == service_id
    end.compact
  end
end

module ServiceHelper
  def add_fields_for(name, f, options={}, &block)
    new_object = OpenStruct.new(persisted?: false)
    f.fields_for(name, new_object, options, &block)
  end

end

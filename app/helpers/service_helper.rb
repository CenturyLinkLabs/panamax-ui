module ServiceHelper
  def add_fields_for(name, f, options={})
    new_object = OpenStruct.new(persisted?: false)
    f.fields_for(name, new_object, options) do |builder|
      render("new_#{name}_fields", f: builder)
    end
  end
end

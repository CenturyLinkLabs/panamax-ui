module ServiceHelper
  def add_fields_for(name, f)
    new_object = OpenStruct.new(persisted?: false)
    f.fields_for(name, new_object, { index: '_replaceme_' }) do |builder|
      render("new_#{name}_fields", f: builder)
    end
  end
end

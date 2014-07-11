class Environment < BaseResource

  schema do
    string :variable
    string :value
    boolean :required
  end
end

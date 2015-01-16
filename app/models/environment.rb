class Environment < BaseResource

  schema do
    string :variable
    string :value
    string :description
  end
end

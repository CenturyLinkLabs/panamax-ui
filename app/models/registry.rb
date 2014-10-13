class Registry < BaseResource

  schema do
    integer :id
    string :name
    string :endpoint_url
  end

end

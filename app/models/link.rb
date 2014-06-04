class Link < BaseResource

  schema do
    integer :service_id
    string :service_name
    string :alias
  end
end

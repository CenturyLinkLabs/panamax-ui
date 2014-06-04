class Category < BaseResource

  self.prefix = '/apps/:app_id/'

  schema do
    integer :id
    string :name
    integer :position
  end
end

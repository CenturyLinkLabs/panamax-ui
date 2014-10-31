class Override < BaseResource

  has_many :images

  schema do
    integer :id
  end
end

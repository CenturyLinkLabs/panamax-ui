class JobTemplate < BaseResource
  has_many :environment

  schema do
    string :name
  end
end

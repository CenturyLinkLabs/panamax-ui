class SearchResultSet < BaseResource
  include ActiveResource::Singleton

  self.singleton_name = 'search'

  has_many :remote_images
  has_many :local_images
  has_many :templates

  schema do
    string :q
  end

end

class User < BaseResource
  include ActiveResource::Singleton

  def repositories
    self.respond_to?(:repos) ? repos : []
  end

  schema do
    string :email
    boolean :github_access_token_present
  end
end

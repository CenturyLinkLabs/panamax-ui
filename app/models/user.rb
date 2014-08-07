class User < BaseResource
  include ActiveResource::Singleton

  schema do
    string :email
    boolean :github_access_token_present
    string :github_access_token
    boolean :subscribe
  end

  def repositories
    self.respond_to?(:repos) ? repos : []
  end
end

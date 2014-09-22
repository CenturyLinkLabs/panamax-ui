class User < BaseResource
  include ActiveResource::Singleton

  schema do
    string :email
    boolean :github_access_token_present
    string :github_access_token
    string :github_username
    boolean :subscribe
  end

  def repositories
    self.respond_to?(:repos) ? repos : []
  end

  def has_valid_github_creds?
    self.github_access_token_present? && self.email.present? && self.github_username.present?
  end


end

class TemplateRepo < BaseResource

  BASE_REPO_ROUTE = 'https://github.com/'

  schema do
    integer :id
    string :name
    date :updated_at
    date :created_at
  end

  def self.find_or_create_by_name(repo)
    repos = self.all
    self.create(name: repo) unless repos.any? { |x| x.name == repo }
  end

  def uri
    BASE_REPO_ROUTE + self.name
  end

  def self.has_user_sources?
    # assuming that we have at least the official one seeded in the sources
    self.all.count > 2
  end
end

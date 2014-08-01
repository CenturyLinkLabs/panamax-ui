class TemplateReposController < ApplicationController

  def index
    @template_repos = TemplateRepo.all
  end

  def reload
    repo = TemplateRepo.new({ id: params[:id] }, persisted = true)
    repo.post(:reload)
    redirect_to template_repos_path
  end
end

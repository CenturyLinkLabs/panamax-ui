class TemplateReposController < ApplicationController

  respond_to :json, only: :destroy

  def index
    @template_repos = TemplateRepo.all
    @template_repo = TemplateRepo.new
  end

  def create
    @template_repo = TemplateRepo.create(name: sanitize_repo_name(params[:template_repo][:name]))
    redirect_to template_repos_url
  rescue => ex
    handle_exception(ex, redirect: template_repos_url)
  end

  def destroy
    repo = TemplateRepo.new({ id: params[:id] }, persisted = true)
    repo.destroy
    respond_with repo
  end

  def reload
    repo = TemplateRepo.new({ id: params[:id] }, persisted = true)
    repo.post(:reload)
    redirect_to template_repos_path
  end

  private

  def sanitize_repo_name(repo_name)
    repo_name = repo_name.gsub('.git', '').split('/')
    if repo_name[2] == 'github.com'
      "#{repo_name[3]}/#{repo_name[4]}"
    else
      "#{repo_name[0]}/#{repo_name[1]}"
    end
  end

end

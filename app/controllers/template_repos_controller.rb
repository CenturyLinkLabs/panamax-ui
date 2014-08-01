class TemplateReposController < ApplicationController
  respond_to :html

  def index
    @template_repos = TemplateRepo.all
  end

end

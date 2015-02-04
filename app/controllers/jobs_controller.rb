class JobsController < ApplicationController
  respond_to :html, only: [:create, :new]
  respond_to :json, only: [:show, :log, :destroy]

  def new
    @template = JobTemplate.find(params[:template_id])
    @job = Job.new_from_template(@template)
    render layout: 'modal'
  end

  def show
    respond_with Job.find(params[:key]).with_step_status!
  end

  def log
    job = Job.new(id: params[:key])
    respond_with job.get(:log, index: params[:index])
  end

  def create
    unless @job = Job.nested_create(params[:job])
      flash[:error] = I18n.t('jobs.create.failure')
    end
    respond_with @job, location: deployment_targets_url
  end

  def destroy
    respond_with(Job.delete(params[:key]))
  end
end

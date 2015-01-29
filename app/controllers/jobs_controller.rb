class JobsController < ApplicationController
  respond_to :html, only: [:create, :new]
  respond_to :json, only: :show

  def new
    @template = JobTemplate.find(params[:template_id])
    @job = Job.new_from_template(@template)
    render layout: 'modal'
  end

  def show
    respond_with Job.find(params[:key]).with_step_status!
  end

  def create
    @job = if Job.nested_create(params[:job])
             flash[:notice] = I18n.t('jobs.create.success')
           else
             flash[:error] = I18n.t('jobs.create.failure')
           end
    respond_with @job, location: deployment_targets_url
  end
end

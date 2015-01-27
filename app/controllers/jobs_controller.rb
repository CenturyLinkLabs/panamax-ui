class JobsController < ApplicationController
  respond_to :html

  def new
    @template = JobTemplate.find(params[:template_id])
    @job = Job.new_from_template(@template)
    render layout: 'modal'
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

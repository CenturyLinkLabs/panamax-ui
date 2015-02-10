class JobPresenter
  def initialize(job, view_context)
    @job = job
    @view_context = view_context
  end

  delegate :status, to: :@job

  def title
    @job.name
  end

  def documentation
    @view_context.markdown_to_html(@job.template.try(:documentation))
  end

  def destroy_path
    @view_context.job_path(@job.key)
  end

  def dom_id
    'job_' + @job.id.to_s
  end

  def message
    if @job.success?
      I18n.t('jobs.completion.success')
    elsif @job.failure?
      I18n.t('jobs.completion.failure')
    end
  end

  def steps(&block)
    @job.steps.map do |step|
      @view_context.capture(step.name, step.status, &block)
    end.join("\n").html_safe
  end
end

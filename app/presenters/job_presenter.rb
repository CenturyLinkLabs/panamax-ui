class JobPresenter
  def initialize(job, view_context)
    @job = job
    @view_context = view_context
  end

  delegate :status, to: :@job

  def title
    @job.name
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

  def unless_running(&block)
    result = @view_context.capture(&block)
    result unless @job.running?
  end

  def steps(&block)
    @job.steps.map do |step|
      @view_context.capture(step.name, step.status, &block)
    end.join("\n").html_safe
  end
end

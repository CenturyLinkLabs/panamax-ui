class JsonJobPresenter
  def initialize(view_context)
    @view_context = view_context
  end

  def title
    '{{name}}'
  end

  def destroy_path
    @view_context.jobs_path + '/{{key}}'
  end

  def dom_id
    'job_{{id}}'
  end

  def status
    '{{status}}'
  end

  def message
    '{{#if success}}' +
      I18n.t('jobs.completion.success_async') +
    '{{else}}' +
      '{{#if failure}}' +
        I18n.t('jobs.completion.failure') +
      '{{/if}}' +
    '{{/if}}'
  end

  def steps(&block)
    result = @view_context.capture('{{this.name}}', '{{this.status}}', &block)
    "{{#each steps}}#{result}{{/each}}".html_safe
  end
end

class JsonJobPresenter
  def initialize(view_context)
    @view_context = view_context
  end

  def title
    '{{key}}'
  end

  def status
    '{{status}}'
  end

  def steps(&block)
    result = @view_context.capture('{{this.name}}', '{{this.status}}', &block)
    "{{#each steps}}#{result}{{/each}}".html_safe
  end
end

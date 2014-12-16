class JsonDeploymentPresenter
  def initialize(target, view_context)
    @target = target
    @view_context = view_context
  end

  def deployment_name
    '{{display_name}}'
  end

  def deployment_id
    '{{id}}'
  end

  def dom_id
    'deployment_{{id}}'
  end

  def destroy_path
    @view_context.deployment_target_deployments_path(@target.id) + '/{{id}}'
  end

  def redeploy_path
    @view_context.deployment_target_deployments_path(@target.id) + '/{{id}}/redeploy'
  end

  def service_count
    '{{status.services.length}}'
  end

  def services(&block)
    result = @view_context.capture('{{this.id}}', '{{this.actualState}}', &block)
    "{{#each status.services}}#{result}{{/each}}".html_safe
  end
end

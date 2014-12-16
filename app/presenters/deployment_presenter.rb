class DeploymentPresenter
  def initialize(target, deployment, view_context)
    @target = target
    @deployment = deployment
    @view_context = view_context
  end

  def deployment_name
    @deployment.display_name
  end

  def deployment_id
    @deployment.id
  end

  def dom_id
    'deployment_' + @deployment.id.to_s
  end

  def destroy_path
    @view_context.deployment_target_deployment_path(@target.to_param, @deployment.to_param)
  end

  def redeploy_path
    @view_context.redeploy_deployment_target_deployment_path(@target.to_param, @deployment.to_param)
  end

  def service_count
    @deployment.service_ids.length
  end

  def services(&block)
    @deployment.service_ids.map do |service_id|
      @view_context.capture(service_id, nil, &block)
    end.join("\n").html_safe
  end
end

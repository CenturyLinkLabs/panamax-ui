class MetricsController < ApplicationController
  respond_to :json

  def index
    respond_with metrics_service.all
  end

  def overall
    respond_with overall_metric(metrics_service.all)
  end

  def overall_metric(metrics)
    metrics['stats'].last.tap do |results|
      results['overall_cpu'] = overall_cpu(metrics['stats'], metrics['spec'])
      results['overall_mem'] = overall_memory(metrics['stats'], metrics['spec'])
    end
  end

  def overall_cpu(stats, spec)
    if stats.count > 1
      sample = stats.pop(2)
      raw = sample[1]['cpu']['usage']['total'] - sample[0]['cpu']['usage']['total']
      usage = (raw / 1000000000.0).round(3)
      percent = (((raw / 1000000.0) / spec['cpu']['limit']) * 100).round(2)
    end
    {
      'usage' => usage || 0,
      'percent' => percent || 0
    }
  end

  def overall_memory(stats, spec)
    if stats.count > 0
      usage = (stats.last['memory']['usage'] / 1024 * 1024).round(3)
      percent = (usage / spec['memory']['limit'] * 100).round(2)
    end
    {
      'usage' => usage || 0,
      'percent' => percent || 0
    }
  end

  private

  def metrics_service
    @metrics_service ||= CadvisorService.new
  end
end

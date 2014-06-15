class MetricService

  attr_accessor :connection

  def initialize(connection = MetricService.default_connection)
    @connection = connection
  end

  def all
    response = connection.get '/api/v1.0/containers/'
    JSON.parse(response.body)
  end

  def overall
    container_info = all
    container_info['stats'].last.tap do |results|
      results['overall_cpu'] = overall_cpu(container_info['stats'], container_info['spec'])
      results['overall_mem'] = overall_memory(container_info['stats'], container_info['spec'])
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

  def self.default_connection
    Faraday.new(url: 'http://localhost:8080')
  end
end

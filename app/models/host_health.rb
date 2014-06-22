require 'active_resource'

class HostHealth < BaseResource
  include ActiveResource::Singleton

  self.site = "#{ENV['CADVISOR_PORT']}"

  def self.singleton_path(_prefix_options={}, _query_options=nil)
    '/api/v1.0/containers/'
  end

  def overall
    self.attributes[:stats].last.tap do |results|
      results.attributes[:overall_mem] = overall_memory(self.attributes[:stats], self.attributes[:spec])
      results.attributes[:overall_cpu] = overall_cpu(self.attributes[:stats], self.attributes[:spec])
    end
  end

  private

  def overall_cpu(stats, spec)
    if stats.count > 1
      sample = stats.pop(2)
      raw = sample[1].attributes[:cpu].attributes[:usage].attributes[:total] -
            sample[0].attributes[:cpu].attributes[:usage].attributes[:total]
      usage = (raw / 1000000000.0).round(3)
      percent = (((raw / 1000000.0) / spec.attributes[:cpu].attributes[:limit]) * 100).round(2)
    end
    {
      'usage' => usage || 0,
      'percent' => percent || 0
    }
  end

  def overall_memory(stats, spec)
    if stats.count > 0
      usage = (stats.last.attributes[:memory].attributes[:usage] / 1024 * 1024).round(3)
      percent = (usage / spec.attributes[:memory].attributes[:limit] * 100).round(2)
    end
    {
      'usage' => usage || 0,
      'percent' => percent || 0
    }
  end
end

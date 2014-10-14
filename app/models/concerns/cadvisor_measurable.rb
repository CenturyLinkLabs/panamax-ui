require 'date'

module CadvisorMeasurable
  extend ActiveSupport::Concern

  def overall
    self.attributes[:stats].last.tap do |results|
      results.attributes[:overall_mem] = overall_memory(self.attributes[:stats], self.attributes[:spec])
      results.attributes[:overall_cpu] = overall_cpu(self.attributes[:stats], self.attributes[:spec])
    end
  end

  private

  def overall_cpu(stats, spec)
    machine_info = MachineInfo.find
    cur = stats[stats.count -1]
    percent = 0

    if (spec.attributes[:has_cpu] && stats.count >=2)
      prev = stats[stats.count - 2]
      raw = (cur.attributes[:cpu].attributes[:usage].attributes[:total] - prev.attributes[:cpu].attributes[:usage].attributes[:total]).abs
      interval = nanosecond_interval(cur.attributes[:timestamp], prev.attributes[:timestamp])
      cores = machine_info.attributes[:num_cores] || 1

      percent = (((raw / interval) / cores) * 100).round
      percent = 100 if percent > 100
    end
    {
        'usage' => raw || 0,
        'percent' => percent || 0
    }

  end

  def overall_memory(stats, spec)
    machine_info = MachineInfo.find
    cur = stats[stats.count -1]

    if (spec.attributes[:has_memory])
      limit = spec.attributes[:memory].attributes[:limit]
      if (limit > machine_info.attributes[:memory_capacity])
        limit = machine_info.attributes[:memory_capacity]
      end
      percent = ((cur.attributes[:memory].attributes[:usage] / limit.to_f) * 100).round
    end
    {
        'usage' => cur.attributes[:memory].attributes[:usage] || 0,
        'percent' => percent || 0,
    }
  end

  def nanosecond_interval(current, previous)
    cur = DateTime.iso8601(current)
    prev = DateTime.iso8601(previous)

    [1, ((cur.to_f - prev.to_f) * 1000000000.0).abs].max
  end

end

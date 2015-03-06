module PanamaxUi
  def self.allow_insecure_registries
    env = ENV['INSECURE_REGISTRY']
    if env.try(:downcase) == 'y'
      'YES'
    else
      'NO'
    end
  end
end

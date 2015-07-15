class RemoteImage < BaseImage
  def remote?
    true
  end

  def docker_index_url
    path_part = (source =~ /\//) ? "u/#{source}" : "_/#{source}"
    "#{DOCKER_INDEX_BASE_URL}#{path_part}"
  end

  def imagelayers_url
    "#{IMAGELAYERS_BASE_URL}?images=#{source}"
  end

  def as_json(options={})
    super
      .merge(
        'docker_index_url' => docker_index_url,
        'imagelayers_url' => imagelayers_url
      )
  end
end

class Image < BaseViewModel
  include ActionView::Helpers::TextHelper

  attr_reader :id, :description, :repository, :star_count, :location

  DOCKER_INDEX_BASE_URL = 'https://index.docker.io/'

  def initialize(attributes)
    super
    @attributes = attributes
  end

  def status_label
    if @attributes['recommended']
      'Recommended'
    elsif @attributes['is_trusted']
      'Trusted'
    elsif local?
      'Local'
    else
      'Repository'
    end
  end

  def recommended_class
    @attributes['recommended'] ? 'recommended' : 'not-recommended'
  end

  def docker_index_url
    if remote?
      path_part = (repository =~ /\//) ? "u/#{repository}" : "_/#{repository}"
      "#{DOCKER_INDEX_BASE_URL}#{path_part}"
    end
  end

  def short_description
    truncate(description, length: 165)
  end

  def as_json(options={})
    super.
      except('attributes').
      merge({
        'status_label' => status_label,
        'short_description' => short_description,
        'recommended_class' => recommended_class,
        'docker_index_url' => docker_index_url
      })
  end

  def local?
    location == self.class.locations[:local]
  end

  def remote?
    location == self.class.locations[:remote]
  end

  def self.locations
    {
      remote: :remote,
      local: :local
    }
  end
end

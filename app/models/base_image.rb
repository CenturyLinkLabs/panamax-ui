class BaseImage < BaseResource
  include ActionView::Helpers::TextHelper

  DOCKER_INDEX_BASE_URL = 'https://index.docker.io/'

  schema do
    integer :id
    string :description
    string :repository
    string :star_count
    string :location
    boolean :recommended
  end

  def status_label
    if recommended
      'Recommended'
    elsif is_trusted
      'Trusted'
    elsif local?
      'Local'
    else
      'Repository'
    end
  end

  def recommended_class
    recommended ? 'recommended' : 'not-recommended'
  end

  def docker_index_url
    if remote?
      path_part = (repository =~ /\//) ? "u/#{repository}" : "_/#{repository}"
      "#{DOCKER_INDEX_BASE_URL}#{path_part}"
    end
  end

  def short_description
    truncate(description, length: 165, escape: false, separator: ' ')
  end

  def as_json(options={})
    super.
      merge({
        'status_label' => status_label,
        'short_description' => short_description,
        'recommended_class' => recommended_class,
        'docker_index_url' => docker_index_url
      })
  end

  def local?
    false
  end

  def remote?
    false
  end
end

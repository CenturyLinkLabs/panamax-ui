class BaseImage < BaseResource
  include ActionView::Helpers::TextHelper

  schema do
    integer :id
    integer :registry_id
    string :description
    string :source
    string :star_count
    string :location
    boolean :is_official
  end

  def self.source(repository, tag=nil)
    "#{repository}:#{tag || 'latest'}"
  end

  def status_label
    if official?
      'Official'
    elsif trusted?
      'Trusted'
    elsif local?
      'Local'
    else
      'Repository'
    end
  end

  def badge_class
    status_label.downcase
  end

  def docker_index_url
    if remote?
      path_part = (source =~ /\//) ? "u/#{source}" : "_/#{source}"
      "#{DOCKER_INDEX_BASE_URL}#{path_part}"
    end
  end

  def short_description
    truncate(description, length: 165, escape: false, separator: ' ')
  end

  def as_json(options={})
    super
      .merge(
        'status_label' => status_label,
        'short_description' => short_description,
        'docker_index_url' => docker_index_url,
        'badge_class' => badge_class
      )
  end

  def official?
    is_official
  end

  def trusted?
    is_trusted
  end

  def local?
    false
  end

  def remote?
    false
  end
end

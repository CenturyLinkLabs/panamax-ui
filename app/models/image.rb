class Image
  include ActiveModel::Model
  include ActionView::Helpers::TextHelper

  attr_reader :id, :description, :repository, :star_count, :location

  DOCKER_INDEX_BASE_URL = 'https://index.docker.io/u/'

  def initialize(attributes)
    @attributes = attributes
    @id = attributes['id']
    @description = attributes['description']
    @repository = attributes['repository']
    @star_count = attributes['star_count']
    @location = attributes['location']
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

  def docker_index_url
    "#{DOCKER_INDEX_BASE_URL}#{repository}" if remote?
  end

  def short_description
    truncate(description, length: 165)
  end

  def as_json(options={})
    super.
      except('attributes').
      merge({
        'status_label' => status_label,
        'short_description' => short_description
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

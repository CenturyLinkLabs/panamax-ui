class Image < BaseResource
  include ApplicationHelper

  has_many :environment

  schema do
    integer :id
    string :category
    string :name
    string :source
    string :description
    string :type
    string :expose
    string :volumes
    string :command
  end

  def environment_attributes=(attrs)
    self.environment = attrs.values.map { |a| a.except('id') }
  end

  def docker_index_url
    path_part = "u/#{self.base_image_name}"
    "#{DOCKER_INDEX_BASE_URL}#{path_part}"
  end

  def base_image_name
    docker_image_name.base_image
  end

  def icon
    type.blank? ? icon_source_for('default') : icon_source_for(type)
  end

  private

  def docker_image_name
    @docker_image_name ||= DockerImageName.parse(source)
  end

end

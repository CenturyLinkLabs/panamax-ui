class Template
  include ActiveModel::Model
  include ActionView::Helpers::TextHelper

  attr_reader :id, :description, :name, :updated_at, :image_count

  def initialize(attributes)
    @id = attributes['id']
    @description = attributes['description']
    @name = attributes['name']
    @updated_at = attributes['updated_at']
    @image_count = attributes['image_count']
  end

  def short_description
    truncate(description, length: 165)
  end

  def image_count_label
    'Image'.pluralize(image_count)
  end

  def as_json(options={})
    super.
      except('attributes').
      merge({
        'short_description' => short_description,
        'image_count_label' => image_count_label
      })
  end
end

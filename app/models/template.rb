class Template
  include ActiveModel::Model
  include ActionView::Helpers::TextHelper

  attr_reader :id, :description, :name, :updated_at, :image_count

  def initialize(attributes)
    @attributes = attributes
    @id = attributes['id']
    @description = attributes['description']
    @name = attributes['name']
    @image_count = attributes['image_count']
  end

  def updated_at
    @attributes['updated_at'].try(:to_time).try(:to_s, :long_ordinal)
  end

  def short_description
    truncate(description, length: 165)
  end

  def image_count_label
    'Image'.pluralize(image_count)
  end

  def recommended
    @attributes['recommended']
  end

  def as_json(options={})
    super.
      except('attributes').
      merge({
        'short_description' => short_description,
        'updated_at' => updated_at,
        'image_count_label' => image_count_label
      })
  end
end

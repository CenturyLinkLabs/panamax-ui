class Template
  include ActiveModel::Model
  include ActionView::Helpers::TextHelper

  attr_reader :id, :description, :name

  def initialize(attributes)
    @attributes = attributes
    @id = attributes['id']
    @description = attributes['description']
    @name = attributes['name']
  end

  def updated_at
    @attributes['updated_at'].try(:to_time).try(:to_s, :long_ordinal)
  end

  def short_description
    truncate(description, length: 165)
  end

  def as_json(options={})
    super.
      except('attributes').
      merge({
        'short_description' => short_description,
        'updated_at' => updated_at
      })
  end
end

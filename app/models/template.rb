class Template
  include ActiveModel::Model
  include ActionView::Helpers::TextHelper

  attr_reader :id, :description, :name, :updated_at

  def initialize(attributes)
    @id = attributes['id']
    @description = attributes['description']
    @name = attributes['name']
    @updated_at = attributes['updated_at']
  end

  def short_description
    truncate(description, length: 165)
  end

  def as_json(options={})
    super.
      except('attributes').
      merge({
        'short_description' => short_description
      })
  end
end

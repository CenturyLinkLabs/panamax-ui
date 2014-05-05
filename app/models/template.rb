class Template < BaseViewModel
  include CollectionBuilder
  include ActionView::Helpers::TextHelper

  attr_reader :id, :description, :name, :image_count

  def initialize(attributes)
    super
    @attributes = attributes
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

  def recommended_class
    @attributes['recommended'] ? 'recommended' : 'not-recommended'
  end

  def icon
    if @attributes['icon'].blank?
      ActionController::Base.helpers.asset_path('template_logos/default.png')
    else
      @attributes['icon']
    end
  end

  def as_json(options={})
    super.
      except('attributes').
      merge({
        'short_description' => short_description,
        'updated_at' => updated_at,
        'image_count_label' => image_count_label,
        'recommended_class' => recommended_class,
        'icon' => icon
      })
  end
end

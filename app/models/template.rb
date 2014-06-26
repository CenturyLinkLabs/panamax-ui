class Template < BaseResource
  include ActionView::Helpers::TextHelper
  include ApplicationHelper

  schema do
    integer :id
    string :description
    date :updated_at
    date :created_at
    string :name
    string :keywords
    string :authors
    string :from
    string :documentation
    integer :app_id
    integer :image_count
    boolean :recommended
    string :icon_src
    string :type
  end

  def last_updated_on
    updated_at.try(:to_time).try(:to_s, :long_ordinal)
  end

  def short_description
    truncate(description, length: 165, escape: false, separator: ' ')
  end

  def image_count_label
    'Image'.pluralize(image_count)
  end

  def recommended_class
    recommended ? 'recommended' : 'not-recommended'
  end

  def icon_src
    if type.blank?
      icon_source_for('default')
    else
      icon_source_for(type)
    end
  end

  def as_json(options={})
    super
      .except('attributes')
      .merge(
        'short_description' => short_description,
        'last_updated_on' => last_updated_on,
        'image_count_label' => image_count_label,
        'recommended_class' => recommended_class,
        'icon_src' => icon_src
      )
  end
end

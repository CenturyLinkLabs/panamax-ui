module VolumeHelper
  def optional_directory(directory, default='Undefined')
    if directory.present?
      content_tag(:strong, directory)
    else
      content_tag(:span, default, class: 'note')
    end
  end
end

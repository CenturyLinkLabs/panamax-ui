module DeploymentHelper
  def deployment_count_options
    1.upto(6).to_a
  end

  def provider_label(provider_name)
    img_path = "providers/logo_#{provider_name.gsub(/\s/, '_').downcase}_small.png"
    if File.exist?(Rails.root.join('app', 'assets', 'images', img_path))
      image_tag(img_path, alt: provider_name)
    else
      provider_name
    end
  end
end

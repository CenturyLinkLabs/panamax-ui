module BreadcrumbHelper
  def breadcrumbs_for(*crumbs)
    max_length = 46
    total_length = determine_length(crumbs)
    if total_length > max_length
      diff = text_only_for(crumbs[1]).length - (total_length - max_length)
      crumbs[1] = truncate_crumb(crumbs[1], diff)
    end
    crumbs
  end

  private

  def truncate_crumb(crumb, length)
    if crumb.starts_with?('<a')
      truncated = truncate(text_only_for(crumb), length: length)
      crumb = crumb.gsub(/(\<a.[^>]*>)[^<]*(\<[^>]*>)/, '\1' + truncated + '\2')
    else
      crumb = truncate(crumb, length: length)
    end
    crumb
  end

  def text_only_for(crumb)
    sanitize(crumb, tags: [])
  end

  def determine_length(crumbs)
    no_html = crumbs.map { |crumb| text_only_for(crumb.to_s) }
    no_html.join('/').length
  end
end

class DashboardController < ApplicationController
  respond_to :html

  def index
    limit = 5
    app_list = App.all_with_response(params: { limit: limit })
    app_count = app_list.response.header['Total-Count'].to_i

    repo_list = TemplateRepo.all_with_response(params: { limit: limit })
    repo_count = repo_list.response.header['Total-Count'].to_i

    image_list = LocalImage.all_with_response(params: { limit: limit })
    image_count = image_list.response.header['Total-Count'].to_i

    registry_list = Registry.all_with_response(params: { limit: limit })
    registry_count = registry_list.response.header['Total-Count'].to_i

    @resources =
      {
        'Application' =>
          {
            list: app_list,
            count: app_count,
            manage_path: apps_path,
            more_count: more_count(app_count, limit)
          },
        'Source' =>
          {
            list: repo_list,
            count: repo_count,
            manage_path: template_repos_path,
            more_count: more_count(repo_count, limit)
          },
        'Image' =>
          {
            list: image_list,
            count: image_count,
            manage_path: images_path,
            more_count: more_count(image_count, limit)
          },
        'Registry' =>
          {
            list: registry_list,
            count: registry_count,
            manage_path: registries_path,
            more_count: more_count(registry_count, limit)
          }
      }
  end

  private

  def more_count(total, limit)
    [0, total - limit].max
  end

end

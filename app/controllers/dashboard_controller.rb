class DashboardController < ApplicationController
  respond_to :html

  def index
    app_count = App.all.length
    repo_count = TemplateRepo.all.length
    image_count = LocalImage.all.length
    registry_count = Registry.all.length
    target_count = DeploymentTarget.all.length

    @resources =
      {
        'Application' =>
          {
            count: app_count,
            manage_path: apps_path,
            message: I18n.t('dashboard.application.message'),
            title: I18n.t('dashboard.application.title')
          },
        'Source' =>
          {
            count: repo_count,
            manage_path: template_repos_path,
            message: I18n.t('dashboard.source.message'),
            title: I18n.t('dashboard.source.title')
          },
        'Image' =>
          {
            count: image_count,
            manage_path: images_path,
            message: I18n.t('dashboard.image.message'),
            title: I18n.t('dashboard.image.title')
          },
        'Registry' =>
          {
            count: registry_count,
            manage_path: registries_path,
            message: I18n.t('dashboard.registry.message'),
            title: I18n.t('dashboard.registry.title')
          },
        'DeploymentTarget' =>
          {
            count: target_count,
            manage_path: deployment_targets_path,
            message: I18n.t('dashboard.target.message'),
            title: I18n.t('dashboard.target.title')
          }
      }
  end
end

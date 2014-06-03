class CategoryPresenter

  delegate :name, :id, to: :category

  def initialize(app, category, services)
    @app = app
    @category = category
    @service_list = services
  end

  def name
    @category.name
  end

  def id
    @category.id
  end

  def app_id
    @app.id
  end

  def services
    @service_list
  end

  private

  attr_reader :service_list, :category, :app
end

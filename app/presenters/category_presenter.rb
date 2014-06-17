class CategoryPresenter

  attr_reader :services

  delegate :name, :id, to: :@category

  def initialize(app, category, services)
    @app = app
    @category = category
    @services = services
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
end

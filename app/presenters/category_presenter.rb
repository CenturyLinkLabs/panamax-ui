class CategoryPresenter

  delegate :name, :id, to: :category

  def initialize(category, services)
    @category = category
    @service_list = services
  end

  def services
    @service_list
  end

  private

  attr_reader :service_list, :category
end

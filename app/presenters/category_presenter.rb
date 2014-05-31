class CategoryPresenter
  def initialize(category, services)
    @category = category
    @service_list = services
  end

  delegate :name, :id, to: :category

  def services
    @service_list
  end

  private

  attr_reader :service_list, :category
end

class ServiceCategory < BaseViewModel
  include CollectionBuilder

  attr_reader :name, :id
end

class AppCategory < BaseViewModel
  include CollectionBuilder

  attr_reader :name, :id
end
module CollectionBuilder
  extend ActiveSupport::Concern

  module ClassMethods
    def instantiate_collection(hashes)
      Array(hashes).map { |hash| self.new(hash) }
    end
  end
end

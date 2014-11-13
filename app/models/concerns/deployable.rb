module Deployable
  extend ActiveSupport::Concern

  def service_defs
    if respond_to? :images
      images
    else
      services
    end
  end
end

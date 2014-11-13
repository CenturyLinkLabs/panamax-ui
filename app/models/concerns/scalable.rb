module Scalable
  extend ActiveSupport::Concern

  def deployment_attributes=(attrs)
    self.deployment = attrs
  end

  def deployment
    Class.new(BaseResource) do
      def count
        1
      end
    end.new
  end

end

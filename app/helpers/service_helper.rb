module ServiceHelper
  def service_details_class(disabled)
    'loading' if disabled
  end
end

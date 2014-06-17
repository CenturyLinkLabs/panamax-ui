module NoticesHelper

  NOTICE_CLASSES = {
    'success' => 'notice-success',
    'notice' => 'notice-default',
    'warning' => 'notice-success',
    'alert' => 'notice-danger'
  }

  def notification_class(key)
    NOTICE_CLASSES[key] || 'notice-default'
  end

end

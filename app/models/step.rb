class Step < BaseResource
  schema do
    integer :id
    integer :order
    string :name
    string :source
  end

  def update_status!(steps_completed, failed)
    self.status = \
      if (steps_completed.to_i + 1) == order
        failed ? 'error' : 'in-progress'
      elsif steps_completed.to_i < order
        failed ? '' : 'waiting'
      else
        'complete'
      end
  end
end

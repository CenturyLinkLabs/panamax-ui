class Step < BaseResource
  schema do
    integer :id
    integer :order
    string :name
    string :source
  end

  def get_status(steps_completed)
    if (steps_completed.to_i + 1) == order
      'in-progress'
    elsif steps_completed.to_i < order
      'waiting'
    else
      'complete'
    end
  end
end

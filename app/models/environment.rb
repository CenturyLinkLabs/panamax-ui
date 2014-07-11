class Environment < BaseResource

  schema do
    string :variable
    string :value
    boolean :required
  end

  def requires_value?
    required.present? && value.blank?
  end
end

class Keyword < BaseResource

  schema do
    integer :count
    string :keyword
  end

  def self.all_sorted_by(key)
    self.all.sort_by { |kw| kw.send(key) }
  end
end

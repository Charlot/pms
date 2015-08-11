class Float
  def to_zero_s
    if self.zero?
      ''
    else
      self.to_s
    end
  end
end
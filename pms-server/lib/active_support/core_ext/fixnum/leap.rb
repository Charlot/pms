class Fixnum
  def leap?
    (self%4==0 && self%100!=0) || self%400==0
  end
end
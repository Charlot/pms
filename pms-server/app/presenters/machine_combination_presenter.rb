class MachineCombinationPresenter<Presenter
  Delegators=[:id, :w1, :t1, :t2, :s1, :s2, :wd1, :w2, :t3, :t4, :s3, :s4, :wd2, :machine_id, :machine]
  def_delegators :@machine_combination, *Delegators

  def initialize(machine_combination)
    @machine_combination=machine_combination
    self.origin=machine_combination
    self.delegators=Delegators
  end

  [:w1, :t1, :t2, :s1, :s2, :w2, :t3, :t4, :s3, :s4].each do |m|
    define_method "#{m}_display" do
      (part=Part.find_by_nr(self.send(m))).nil? ? '' : part.nr
    end
  end

  def wd1_display
    self.wd1
  end

  def wd2_display
    self.wd2
  end
end
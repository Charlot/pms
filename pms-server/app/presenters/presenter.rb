class Presenter
  attr_accessor :delegators, :origin
  extend Forwardable

  def self.init_presenters params
    params.map { |param| self.new(param) }
  end

  def self.init_json_presenters params
    params.map { |param| self.new(param).to_json }
  end

  def to_json
    json={}
    self.delegators.each do |dele|
      json[dele]=self.send(dele)
    end
    return json
  end

  # def self.model_name
  #   self.name.sub(/Presenter/, '').constantize
  # end
end
class Warehouse < ActiveRecord::Base
  validates :nr, presence: true, uniqueness: {message: 'nr should be uniq'}


  PREFIX_WHOUSE={'^MC' => 'SRP1',
                 '^XF' => 'SRP1',
                 '^XT' => 'SRP1',
                 '^XM' => '3PL'}

  def self.get_whouse_by_position_prefix(position_nr)
    PREFIX_WHOUSE.each do |k, v|
      return v if /#{k}/.match(position_nr)
    end
    return nil
  end
end

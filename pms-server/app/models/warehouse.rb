class Warehouse < ActiveRecord::Base
  validates :nr, presence: true, uniqueness: {message: 'nr should be uniq'}


  PREFIX_WHOUSE={'^MC' => 'SRPL',
                 '^FC' => 'SRPL',
                 '^TC' => 'SRPL',
                 # '^XM' => '3Main',
                 # '^XF' => '3Floor',
                 # '^XT' => '3PL'
                 '^XM' => '3PL',
                 '^XF' => '3PL',
                 '^XT' => '3PL'
  }


  def self.get_whouse_by_position_prefix(position_nr)
    PREFIX_WHOUSE.each do |k, v|
      return v if /#{k}/.match(position_nr)
    end
    return nil
  end
end

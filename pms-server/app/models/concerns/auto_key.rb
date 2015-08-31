module AutoKey

  extend ActiveSupport::Concern
  included do
    before_create :generate_auto_key

    def self.reset_auto_key
      $redis.set "auto_key:#{self.name}", 0
    end

    def generate_auto_key
      key=redis_incr_key
      if key.to_s.length<6
        self.nr= '%06d' % key
      else
        self.nr= "%0#{key.to_s.length+1}d" % key
      end
    end

    def redis_incr_key
      $redis.incr "auto_key:#{self.class.name}"
    end
  end
end

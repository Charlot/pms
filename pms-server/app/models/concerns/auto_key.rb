module AutoKey

  extend ActiveSupport::Concern
  included do
    before_create :generate_auto_key

    def self.reset_auto_key
      $redis.set "auto_key:#{self.name}", 0
    end

    def generate_auto_key
      self.nr= '%06d' % redis_incr_key
    end

    def redis_incr_key
      $redis.incr "auto_key:#{self.class.name}"
    end
  end
end
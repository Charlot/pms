module APIGuard
  extend ActiveSupport::Concern
  included do |base|
    helpers HelperMethods
  end

  module HelperMethods
    def guard!
      authenticate!
    end

    def user_signed_in?
      !current_user.nil?
    end

    def current_user
      warden.user
    end

    def warden
      request.env['warden']
    end

    def authenticate!
      unless warden.authenticate?
        return error!({result: 0}, 401)
      end
    end
  end

  module ClassMethods
    def guard_all!
      before do
        guard!
      end
    end
  end
end

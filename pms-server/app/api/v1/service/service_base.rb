module V1
  module Service
    class ServiceBase < ApplicationAPI
      include OauthAPIGuard
      version 'v1',
              :using => :path
      namespace :service do
        mount PrintServiceAPI
        mount MachineServiceAPI
      end
    end
  end
end

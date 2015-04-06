module V1
  module Service
    class ServiceBase < ApplicationAPI
      include OauthAPIGuard
      version 'v1',
              :using => :path
      namespace :service do
        mount PrintServiceAPI
        # mount MachineServiceAPI
        mount NcrServiceAPI
        mount KanbanServiceAPI
      end
    end
  end
end

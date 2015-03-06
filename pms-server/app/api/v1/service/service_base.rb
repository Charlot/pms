module V1
  module Service
    class ServiceBase<ApplicationAPI
      include OauthAPIGuard
      version 'v1', :using => :path
      namespace 'service'
      mount PrintServiceAPI
    end
  end
end
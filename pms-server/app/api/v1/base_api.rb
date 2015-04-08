module V1
  class BaseAPI<ApplicationAPI
    include OauthAPIGuard
    version 'v1',
            :using => :path
  end
end
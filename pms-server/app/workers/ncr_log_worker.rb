class NcrLogWorker
  include Sidekiq::Worker

  def perform(params)
    NcrApiLog.create(params)
  end
end
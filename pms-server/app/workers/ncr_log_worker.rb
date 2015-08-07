class NcrLogWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :ncr_log, retry: false)

  def perform(params)
    NcrApiLog.create(params)
  end
end
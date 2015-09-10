require 'redis'
require 'redis-namespace'


$redis= Redis::Namespace.new('pms-server', redis: Redis.new(:host => '127.0.0.1', :port => '6379', :db => 0))

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      $redis.client.disconnect
      $redis= Redis::Namespace.new('pms-server', redis: Redis.new(:host => '127.0.0.1', :port => '6379', :db => 0))
    end
  end
end

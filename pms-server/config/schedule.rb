# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
set :output, {:error => 'log/cron_error_log.log', :standard => 'log/cron_log.log'}

#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
set :environment, :development
# Learn more: http://github.com/javan/whenever
every :reboot do
  rake 'sidekiq:start'
end

every 1.day, :at => ['00:58','01:02','01:05'] do
  command "cd /home/charlot/project/pms/pms-server/ && backup perform -t db_backup --config-file='./config/backup/config.rb'"
end
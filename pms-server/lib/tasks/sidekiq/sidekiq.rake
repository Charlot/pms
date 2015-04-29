namespace :sidekiq do
  desc "TODO"
  task :start => :environment do
    system *%W(script/sidekiq_jobs start)
  end

  task :stop => :environment do
    system *%W(script/sidekiq_jobs stop)
  end
end

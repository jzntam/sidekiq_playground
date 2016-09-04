require 'sidekiq'

# Configure Sidekiq client to connect to Redis using a custom database.
# Allows us to run multiple apps on the same Redis without interference
Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

# Congifuter the Sidekiq server
Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class OurWorker
  include Sidekiq::Worker
  # set the number of times Sidekiq should retry a job
  sidekiq_options retry: 0

  # To simulate different amounts of work, we just add sleep statements
  def perform(complexity)
    case complexity
    when "super_hard"
      puts "\nCharging a credit card...\n"
      raise "Woops stuff got bad"
      puts "\nReally took quite a bit of effort\n"
    when "hard"
      sleep 10
      puts "\nThat was a bit of work\n"
    else
      sleep 1
      puts "\nThat wasn't a lot of effort\n"
    end
  end
end

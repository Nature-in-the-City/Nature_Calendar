PumaWorkerKiller.config do |config|
  config.rolling_restart_frequency = 60 # 60 seconds
end
PumaWorkerKiller.start
puts 'Stared Puma Worker Killer'
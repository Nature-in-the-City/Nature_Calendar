PumaWorkerKiller.config do |config|
  config.rolling_restart_frequency = 30 # 30 seconds
end
PumaWorkerKiller.start
puts 'Stared Puma Worker Killer'
Rails.application.config.to_prepare do
  # Clear up / reset some ephemeral data if the server is restarting
  Rails.cache.write("REGION:#{Region.current}:USERCOUNT", 0, raw: true)
  Rails.cache.delete_matched("REGION:#{Region.current}:USERTABS:*")

  # Run KeySubscriber in a separate thread
  Thread.new { KeySubscriber.new }
end

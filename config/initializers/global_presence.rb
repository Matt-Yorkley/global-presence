Rails.application.config.to_prepare do
  # Clear up / reset some ephemeral data if the server is restarting
  EventKeys.clear_transient

  # Run KeySubscriber in a separate thread
  Thread.new do
    Rails.application.executor.wrap do
      KeySubscriber.new
    end
  end
end

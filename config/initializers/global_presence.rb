Rails.application.config.to_prepare do
  # Run KeySubscriber in a separate thread
  Thread.new { KeySubscriber.new }
end

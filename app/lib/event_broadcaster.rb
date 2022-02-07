class EventBroadcaster
  include CableReady::Broadcaster

  def process_event(command, key)
    # Process keychange events
  end

  private

  def redis
    Rails.cache.redis
  end
end

class KeySubscriber
  def initialize
    redis_client.psubscribe("__key*__:*") do |on|
      on.psubscribe do
        @handler = EventBroadcaster.new
      end
      on.pmessage do |_pattern, command, key|
        @handler.process_event(command.split(":").last.to_sym, key)
      end
      on.punsubscribe do
        @handler = nil
      end
    end
  end

  def redis_client
    client = Redis.new(Rails.cache.redis_options.merge(read_timeout: 0))
    client.config(:set, "notify-keyspace-events", "E$lshz")
    client
  end
end

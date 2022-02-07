class EventKeys
  class << self
    def get_lightbulb_state
      JSON.parse(
        Rails.cache.redis.get("REGION:GLOBAL:LIGHT") || "{}"
      )
    end

    def set_lightbulb_state(event_data)
      Rails.cache.redis.set("REGION:GLOBAL:LIGHT", event_data.to_json)
    end

    def push_hi_message(event_data)
      Rails.cache.redis.lpush("REGION:GLOBAL:SAYHI", event_data.to_json)
      Rails.cache.redis.ltrim("REGION:GLOBAL:SAYHI", 0, 10)
    end

    def get_hi_messages(count = 8)
      Rails.cache.redis.lrange("REGION:GLOBAL:SAYHI", 0, count)
    end

    def get_last_hi_message
      JSON.parse(
        Rails.cache.redis.lrange("REGION:GLOBAL:SAYHI", 0, 1).first
      )
    end

    def get_user_count(region_id)
      Rails.cache.read("REGION:#{region_id}:USERCOUNT", raw: true)
    end

    def get_tab_count(region_id, request_id)
      Rails.cache.read("REGION:#{region_id}:USERTABS:#{request_id}", raw: true).to_i
    end

    def increment_tab_count(region_id, request_id)
      Rails.cache.increment("REGION:#{region_id}:USERTABS:#{request_id}")
    end

    def decrement_tab_count(region_id, request_id)
      Rails.cache.decrement("REGION:#{region_id}:USERTABS:#{request_id}")
    end

    def delete_tab_count(region_id, request_id)
      Rails.cache.delete("REGION:#{region_id}:USERTABS:#{request_id}")
    end

    def increment_user_count(region_id)
      Rails.cache.increment("REGION:#{region_id}:USERCOUNT")
    end

    def decrement_user_count(region_id)
      Rails.cache.decrement("REGION:#{region_id}:USERCOUNT")
    end

    def clear_transient
      Rails.cache.write("REGION:#{Region.current}:USERCOUNT", 0, raw: true)
      Rails.cache.delete_matched("REGION:#{Region.current}:USERTABS:*")
    end
  end
end

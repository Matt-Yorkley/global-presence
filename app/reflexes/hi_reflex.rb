# frozen_string_literal: true

class HiReflex < ApplicationReflex
  def say_hi
    push_message_to_list(element.dataset["colour"])

    morph :nothing
  end

  private

  def push_message_to_list(user_colour)
    Rails.cache.redis.lpush(
      "REGION:GLOBAL:SAYHI",
      {
        request_id: connection.request_id,
        time: Time.now.to_i,
        region: Region.current,
        colour: user_colour
      }.to_json
    )

    Rails.cache.redis.ltrim("REGION:GLOBAL:SAYHI", 0, 10)
  end
end

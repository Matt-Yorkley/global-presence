# frozen_string_literal: true

class LightbulbReflex < ApplicationReflex
  def toggle
    set_lightbulb_state

    morph :nothing
  end

  private

  def set_lightbulb_state
    current_state = JSON.parse((Rails.cache.redis.get("REGION:GLOBAL:LIGHT") || "{}"))["on"]

    Rails.cache.redis.set(
      "REGION:GLOBAL:LIGHT",
      {
        request_id: connection.request_id,
        region: Region.current,
        on: !current_state
      }.to_json
    )
  end
end

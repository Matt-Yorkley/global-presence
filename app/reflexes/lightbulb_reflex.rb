# frozen_string_literal: true

class LightbulbReflex < ApplicationReflex
  def toggle
    set_lightbulb_state

    morph :nothing
  end

  private

  def set_lightbulb_state
    current_state = EventKeys.get_lightbulb_state["on"]

    EventKeys.set_lightbulb_state(
      request_id: connection.request_id,
      region: Region.current,
      on: !current_state
    )
  end
end

class EventBroadcaster
  include CableReady::Broadcaster

  delegate :render, to: ::ApplicationController

  def process_event(command, key)
    return unless key.to_s.start_with? "REGION:"
    return unless command.in? [:set, :lpush, :incrby, :decrby]

    update_user_count(key)  if key.match?(":USERCOUNT")
    toggle_light(key)       if key.match?(":LIGHT")
    update_tab_count(key)   if key.match?(":USERTABS")
    append_hi_message(key)  if key.match?(":SAYHI") && command == :lpush

    cable_ready.broadcast
  end

  private

  def update_user_count(key)
    region_id = key.split(":").second

    cable_ready["#{Region.current}:telegraph"].replace(
      selector: "##{region_id}_usercount",
      html: render(partial: "home/usercount",
                   locals: { region_id: region_id, usercount: Region.usercount(region_id) })
    )
  end

  def toggle_light(key)
    lightbulb_data = EventKeys.get_lightbulb_state

    if lightbulb_data["on"]
      cable_ready["#{Region.current}:telegraph"].add_css_class("#lightbulb", name: "on")
    else
      cable_ready["#{Region.current}:telegraph"].remove_css_class("#lightbulb", name: "on")
    end

    cable_ready["#{Region.current}:telegraph"].inner_html(
      selector: "#lightswitch-label",
      html: "Last clicked by: User ##{lightbulb_data["request_id"].to_s[0,8].upcase}"
    )
  end

  def update_tab_count(key)
    request_id = key.split(":").last

    cable_ready["#{Region.current}:user:#{request_id}"].
      inner_html("#tabcount", html: Region.tabcount(request_id))
  end

  def append_hi_message(key)
    message = EventKeys.get_last_hi_message

    cable_ready["#{Region.current}:telegraph"].
      prepend("#messages-body", html: render(partial: "home/message", locals: { message: message }))
  end
end

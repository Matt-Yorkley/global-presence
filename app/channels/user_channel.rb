class UserChannel < ApplicationCable::Channel
  include CableReady::Broadcaster

  def subscribed
    stream_from "#{Region.current}:user:#{connection.request_id}"

    broadcast_tab_count
  end

  private

  def broadcast_tab_count
    cable_ready["#{Region.current}:user:#{connection.request_id}"].
      inner_html("#tabcount", html: Region.tabcount(connection.request_id)).
      broadcast
  end
end

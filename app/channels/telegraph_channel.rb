class TelegraphChannel < ApplicationCable::Channel
  include CableReady::Broadcaster

  delegate :render, to: ::ApplicationController

  def subscribed
    stream_from "telegraph"

    broadcast_user_count
  end

  private

  def broadcast_user_count
    cable_ready["telegraph"].replace(
      selector: "##{Region.current}_usercount",
      html: render(partial: "home/usercount",
                   locals: { region_id: Region.current, usercount: Region.usercount(Region.current) })
    ).broadcast
  end
end

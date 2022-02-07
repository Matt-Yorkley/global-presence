class TelegraphChannel < ApplicationCable::Channel
  def subscribed
    stream_from "telegraph"
  end
end

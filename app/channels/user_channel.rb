class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user:#{connection.request_id}"
  end
end

class HomeController < ApplicationController
  def show
    @request_id = Digest::SHA2.hexdigest(request.session.id.to_s)
    @lightbulb_state = JSON.parse(Rails.cache.redis.get("REGION:GLOBAL:LIGHT") || "{}")
    @latest_messages = Rails.cache.redis.lrange("REGION:GLOBAL:SAYHI", 0, 5)
  end
end

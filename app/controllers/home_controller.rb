class HomeController < ApplicationController
  def show
    @request_id = Digest::SHA2.hexdigest(request.session.id.to_s)
    @lightbulb_state = EventKeys.get_lightbulb_state
    @latest_messages = EventKeys.get_hi_messages
  end
end

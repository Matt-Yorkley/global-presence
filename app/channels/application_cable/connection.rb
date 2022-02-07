module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :request_id

    def connect
      self.request_id = Digest::SHA2.hexdigest(request.session.id.to_s)

      track_user_connected
    end

    def disconnect
      track_user_disconnected
    end

    private

    def track_user_connected
      tab_count = EventKeys.increment_tab_count(Region.current, self.request_id)

      unless tab_count > 1
        EventKeys.increment_user_count(Region.current)
      end
    end

    def track_user_disconnected
      if current_tab_count > 1
        EventKeys.decrement_tab_count(Region.current, self.request_id)
      else
        EventKeys.delete_tab_count(Region.current, self.request_id)
        EventKeys.decrement_user_count(Region.current)
      end
    end

    def current_tab_count
      EventKeys.get_tab_count(Region.current, self.request_id)
    end
  end
end

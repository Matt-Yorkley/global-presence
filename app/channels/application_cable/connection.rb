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
      tab_count = Rails.cache.increment("REGION:#{Region.current}:USERTABS:#{self.request_id}")

      unless tab_count > 1
        Rails.cache.increment("REGION:#{Region.current}:USERCOUNT")
      end
    end

    def track_user_disconnected
      tab_count = Rails.cache.read("REGION:#{Region.current}:USERTABS:#{self.request_id}", raw: true).to_i

      if tab_count > 1
        Rails.cache.decrement("REGION:#{Region.current}:USERTABS:#{self.request_id}")
      else
        Rails.cache.delete("REGION:#{Region.current}:USERTABS:#{self.request_id}")
        Rails.cache.decrement("REGION:#{Region.current}:USERCOUNT")
      end
    end
  end
end

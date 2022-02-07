module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :request_id

    def connect
      self.request_id = Digest::SHA2.hexdigest(request.session.id.to_s)
    end
  end
end

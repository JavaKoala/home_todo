module HomeCalendar
  class HomeCalendarService
    def self.event_from_todo(todo)
      event = Event.new
      event.assign_attributes(
        title: todo.description,
        start: todo.due,
        end: todo.due + 1.hour
      )

      event
    end

    def self.create_event(event)
      return if event.invalid? || !Rails.application.config.home_calendar[:enabled]

      conn = Faraday.new(
        url: Rails.application.config.home_calendar[:url],
        headers: { 'Content-Type' => 'application/json' }
      ) do |faraday|
        faraday.response :raise_error
      end

      conn.post('/api/v1/events', event.to_json)
    end
  end
end

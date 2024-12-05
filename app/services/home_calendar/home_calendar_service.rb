module HomeCalendar
  class HomeCalendarService
    def send_todo_to_calendar(todo_id)
      todo = Todo.find_by(id: todo_id)

      return if todo.blank?

      event = event_from_todo(todo)
      create_event(event)
    end

    def event_from_todo(todo)
      event = Event.new
      event.assign_attributes(
        title: todo.description,
        start: todo.due,
        end: todo.due + 1.hour
      )

      event
    end

    def create_event(event)
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

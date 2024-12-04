class CreateEventJob < ApplicationJob
  queue_as :default

  def perform(todo_id)
    event = HomeCalendar::HomeCalendarService.event_from_todo(Todo.find(todo_id))
    HomeCalendar::HomeCalendarService.create_event(event)
  end
end

class CreateEventJob < ApplicationJob
  queue_as :default

  def perform(todo_id)
    HomeCalendar::HomeCalendarService.new.send_todo_to_calendar(todo_id)
  end
end

require 'rails_helper'

RSpec.describe HomeCalendar::HomeCalendarService do
  describe '#send_todo_to_calendar' do
    before do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(true)
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:url).and_return('http://localhost:3001/api/v1')
      allow(Faraday).to receive(:new).and_return(faraday_connection)
    end

    let(:service) { described_class.new }
    let(:faraday_connection) { instance_double(Faraday::Connection, post: true) }

    it 'creates a new event' do
      list = List.create(name: 'My List')
      todo = Todo.create(description: 'My Todo', due: Time.zone.now, list: list)

      service.send_todo_to_calendar(todo.reload.id)
      expect(faraday_connection).to have_received(:post)
    end

    it 'does not create a new event if the todo cannot be found' do
      service.send_todo_to_calendar(1)
      expect(faraday_connection).not_to have_received(:post)
    end
  end

  describe '#event_from_todo' do
    let(:service) { described_class.new }

    it 'sets the title from a todo' do
      todo = Todo.new(description: 'My Todo', due: Time.zone.now)

      event = service.event_from_todo(todo)

      expect(event.title).to eq 'My Todo'
    end

    it 'sets the start from a todo' do
      todo = Todo.new(description: 'My Todo', due: Time.zone.now)

      event = service.event_from_todo(todo)

      expect(event.start).to eq todo.due
    end

    it 'sets the end from a todo' do
      todo = Todo.new(description: 'My Todo', due: Time.zone.now)

      event = service.event_from_todo(todo)

      expect(event.end).to eq todo.due + 1.hour
    end
  end

  describe '#create_event' do
    before do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(true)
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:url).and_return('http://localhost:3001/api/v1')
      allow(Faraday).to receive(:new).and_return(faraday_connection)
    end

    let(:service) { described_class.new }
    let(:event) { Event.new }
    let(:faraday_connection) { instance_double(Faraday::Connection, post: true) }

    def set_valid_event
      event.title = 'Test Event'
      event.start = Time.zone.now
      event.end = 1.hour.from_now
    end

    it 'calls the create event api' do
      set_valid_event

      service.create_event(event)

      expect(faraday_connection).to have_received(:post).with('/api/v1/events', event.to_json)
    end

    it 'does not create an event if it is not valid' do
      service.create_event(event)

      expect(faraday_connection).not_to have_received(:post).with('/api/v1/events', event.to_json)
    end

    it 'does not create an event if feature not enabled' do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(false)
      set_valid_event

      service.create_event(event)

      expect(faraday_connection).not_to have_received(:post).with('/api/v1/events', event.to_json)
    end
  end
end

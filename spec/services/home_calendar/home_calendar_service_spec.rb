require 'rails_helper'

RSpec.describe HomeCalendar::HomeCalendarService do
  describe '.event_from_todo' do
    it 'sets the title from a todo' do
      todo = Todo.new(description: 'My Todo', due: Time.zone.now)

      event = described_class.event_from_todo(todo)

      expect(event.title).to eq 'My Todo'
    end

    it 'sets the start from a todo' do
      todo = Todo.new(description: 'My Todo', due: Time.zone.now)

      event = described_class.event_from_todo(todo)

      expect(event.start).to eq todo.due
    end

    it 'sets the end from a todo' do
      todo = Todo.new(description: 'My Todo', due: Time.zone.now)

      event = described_class.event_from_todo(todo)

      expect(event.end).to eq todo.due + 1.hour
    end
  end

  describe '.create_event' do
    before do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(true)
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:url).and_return('http://localhost:3001/api/v1')
      allow(Faraday).to receive(:new).and_return(faraday_connection)
    end

    let(:event) { Event.new }
    let(:faraday_connection) { instance_double(Faraday::Connection, post: true) }

    def set_valid_event
      event.title = 'Test Event'
      event.start = Time.zone.now
      event.end = 1.hour.from_now
    end

    it 'calls the create event api' do
      set_valid_event

      described_class.create_event(event)

      expect(faraday_connection).to have_received(:post).with('/api/v1/events', event.to_json)
    end

    it 'does not create an event if it is not valid' do
      described_class.create_event(event)

      expect(faraday_connection).not_to have_received(:post).with('/api/v1/events', event.to_json)
    end

    it 'does not create an event if feature not enabled' do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(false)
      set_valid_event

      described_class.create_event(event)

      expect(faraday_connection).not_to have_received(:post).with('/api/v1/events', event.to_json)
    end
  end
end

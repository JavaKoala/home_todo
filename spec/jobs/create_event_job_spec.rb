require 'rails_helper'

RSpec.describe CreateEventJob do
  describe '.perform_later' do
    it 'enqueues an event' do
      ActiveJob::Base.queue_adapter = :test

      expect do
        described_class.perform_later(1)
      end.to have_enqueued_job
    end
  end
end

module Job
  class Unpublish
    include Resque::Plugins::Status
    include RunAsBatchItem

    def self.queue
      :unpublish
    end

    def self.create(options)
      required = [:record_id, :user_id, :batch_id]
      raise ArgumentError.new("Required keys: #{required}") if (required - options.keys).present?
      super
    end

    def perform
      tick # give resque-status a chance to kill this

      run_as_batch_item(options['record_id'], options['batch_id']) do |record|
        UnpublishService.new(record, options['user_id']).run
      end
    end
  end
end
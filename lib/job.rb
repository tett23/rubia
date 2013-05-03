# coding: utf-8

module Rubia
  class JobManager
    TYPES = [:build_epub]

    def self.push(type, target, options={})
      defalut = {
        callback: nil
      }
      options = defalut.merge(options)
      job = {}
      raise 'invalid job type' if TYPES.index(type).nil?
      job[:type] = type

      case type
      when :build_epub
        job[:work_id] = target.id
      end

      job = Job.create(job)
      JobQueue.create(job: job)
    end

    def self.last
      JobQueue.all(order: :priority).last
    end

    def self.first
      JobQueue.all(order: :priority).first
    end

    def self.[](*args)
      JobQueue.all(order: :priority)[*args]
    end

    def self.at(index)
      JobQueue.all(order: :priority)[index]
    end

    def self.process_first
      queue_item = JobManager.first
      return nil if queue_item.nil?

      queue_item.update(is_running: true)
      log = JobLog.create(job: queue_item.job)
      queue_item.job.update(log: log)

      if queue_item.job.process
        begin
          eval(queue_item.callback) unless queue_item.callback.blank?
        rescue
          error_message = [$!.message, $!.backtrace.join("\n")].join("\n")
          error_message = [queue_item.log.body.to_s, error_message].join("\n")

          log.update(body: error_message)
        end
      end
      log.update(finish_at: Time.now)

      queue_item.destroy
    end
  end
end

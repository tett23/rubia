# coding: utf-8

module Rubia
  class JobManager
    TYPES = [:build_epub]

    def self.push(type, target, options={})
      defalut = {
        callback: nil,
        data: nil
      }
      options = defalut.merge(options)
      job = {}
      raise 'invalid job type' if TYPES.index(type).nil?
      job[:type] = type
      job[:data] = options[:data]

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
      append_log(queue_item.job)

      execute_callback(queue_item) if queue_item.job.process
      queue_item.job.log.update(finish_at: Time.now)

      queue_item.destroy
    end

    private
    def self.append_log(job)
      log = JobLog.create(job: job)
      job.update(log: log)
    end

    def self.execute_callback(queue)
      begin
        eval(queue.callback) unless queue.callback.blank?
      rescue
        error_message = [$!.message, $!.backtrace.join("\n")].join("\n")
        error_message = [queue.job.log.body.to_s, error_message].join("\n")

        queue.job.log.update(body: error_message)
      end
    end
  end
end

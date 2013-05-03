# coding: utf-8

class JobQueue
  include DataMapper::Resource

  property :id, Serial
  property :priority, Integer, default: lambda {|r, p|
    JobQueue.last_priority
  }
  property :callback, Text
  property :is_running, Boolean, default: false
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :job

  def self.last_priority
    queue = JobQueue.all(order: :priority.desc).first
    return 1 if queue.nil?

    queue.priority+1
  end
end

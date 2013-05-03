# coding: utf-8

class JobLog
  include DataMapper::Resource

  property :id, Serial
  property :body, Text
  property :start_at, DateTime, default: lambda { |r, p| Time.now }
  property :finish_at, DateTime
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :job
end

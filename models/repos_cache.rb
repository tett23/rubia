# coding: utf-8

class ReposCache
  include DataMapper::Resource

  property :id, Serial
  property :commit_hash, String
  property :commit_at, DateTime
  property :commit_message, Text
  property :groonga_key, String
  property :filename, String
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :work, required: false
end

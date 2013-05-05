# coding: utf-8

class ReposCache
  include DataMapper::Resource

  property :id, Serial
  property :commit_hash, String
  property :commit_at, DateTime
  property :commit_message, Text
  property :branch_name, String
  property :groonga_key, String
  property :filename, String
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :work, required: false

  attr_accessor :body

  def self.search(query, options)
    options = {
      order: commit_at
    }.merge(options)

    cache= self.first(options)
    commit_hash = cache.commit_hash
    commit_at = cache.commit_at

    Rubia::Groonga::ReposCache.find(query, commit_hash).map do |hash|
      next unless hash.commit_hash == commit_hash

      hash
    end.compact.map do |hash|
      work = self.first(groonga_key: hash.key.key)
      next if work.nil?

      work.body = hash.body

      work
    end.compact
  end
end

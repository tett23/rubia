# coding: utf-8

class Work
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :slug, Slug

  def self.list
    self.all
  end

  def self.detail(slug)
    self.first(slug: slug)
  end
end

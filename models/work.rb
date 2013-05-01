# coding: utf-8

class Work
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :slug, Slug

  belongs_to :account

  def self.list(account_id, options={})
    default = {
      account_id: account_id
    }
    options = default.merge(options)

    self.all(options)
  end

  def self.detail(slug)
    self.first(slug: slug)
  end
end

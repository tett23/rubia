# coding: utf-8

class Work
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :slug, Slug

  belongs_to :account

  validates_with_method :check_unique_slug

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

  private
  def check_unique_slug
    already = Work.first(slug: self.slug, account_id: self.account_id)
    if already.nil?
      true
    else
      [false, "識別子#{self.slug}はすでに使われています"]
    end
  end
end

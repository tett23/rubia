# coding: utf-8

class JobQueue
  include DataMapper::Resource

  property :id, Serial
  property :type, Enum[:build_epub]
  property :priority, Integer, :default=>lambda {|r, p|
    JobQueue.last_priority
  }
  property :callback, Text
  property :is_running, Boolean, :default=>false
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :work, required: false

  def process
    case self.type
    when :build_epub
      in_path = [Rubia::REPOS_DIR, self.work.slug].join('/')
      out_path = [Rubia::ARCHIVE_DIR, self.work.account.screen_name, "#{work.slug}.zip"].join('/')
      out_dir = [Rubia::ARCHIVE_DIR, self.work.account.screen_name].join('/')
      FileUtils.mkdir_p(out_dir) unless Dir.exists?(out_dir)

      book = Rubia::Epubgen::Book.new(self.work.slug, in_path)
      book.to_epub(out_path)
    end

    self.destroy
  end
end

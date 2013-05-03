# coding: utf-8

class Job
  include DataMapper::Resource

  property :id, Serial
  property :type, Enum[*Rubia::JobManager::TYPES], required: true
  property :status, Enum[:unexecuted, :in_progress, :failure, :success], default: :unexecuted
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :work, required: false
  belongs_to :log, 'JobLog', required: false
  belongs_to :queue, 'JobQueue', required: false

  def process
    self.update(status: :in_progress)

    begin
      case self.type
      when :build_epub
        in_path = [Rubia::REPOS_DIR, self.work.slug].join('/')
        out_path = [Rubia::ARCHIVE_DIR, self.work.account.screen_name, "#{work.slug}.zip"].join('/')
        out_dir = [Rubia::ARCHIVE_DIR, self.work.account.screen_name].join('/')
        FileUtils.mkdir_p(out_dir) unless Dir.exists?(out_dir)

        book = Rubia::Epubgen::Book.new(self.work.slug, in_path)
        book.to_epub(out_path)
      end

      self.update(status: :success)
    rescue
      error_message = [$!.message, $!.backtrace.join("\n")].join("\n")
      self.log.update(body: error_message)
      self.update(status: :failure)

      return false
    end

    true
  end
end

# coding: utf-8

namespace :repos do
  task :create_db_cache do
    RUBIA_DIR = pwd.gsub(/(.+rubia)\/.+/, '\1')
    PADRINO_ROOT = RUBIA_DIR
    Rubia::REPOS_DIR = [PADRINO_ROOT, 'repos'].join('/')

    Rubia::Groonga.open

    works = Work.all
    works.each do |work|
      repos = Rubia::Repos.get(work.slug)
      g = repos.repos

      g.branches.local.each do |branch|
        g.checkout(branch)
        commit = g.log.first
        cache = {
          commit_hash: commit.sha,
          commit_at: commit.date,
          commit_message: commit.message,
          branch_name: branch.name,
          work_id: work.id
        }

        search = repos.data_dir+'/**/*'
        Dir.glob(search).each do |entry|
          next if File.directory?(entry)

          original_file = open(entry, 'rb').read
          next if original_file.match("\0") # ヌル文字ありでバイナリファイルとみなす
          text = original_file.force_encoding('utf-8') rescue next

          filename = entry.gsub(repos.data_dir+'/', '')
          data = cache.dup
          data[:filename] = filename

          content_body = Rubia::Groonga::ReposCache.add(cache[:commit_hash], text)
          data[:groonga_key] = content_body.key

          if ReposCache.first(commit_hash: data[:commit_hash], filename: data[:filename]).nil?
            ReposCache.create(data)
          end
        end
      end

      g.checkout('master')
    end
  end
end

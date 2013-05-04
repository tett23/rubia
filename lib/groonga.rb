# coding: utf-8

require 'groonga'

module Rubia
  module Groonga
    SCHEMA_DIR = File.join(File.expand_path('../..', __FILE__), 'config/groonga')
    extend self

    def open
      ::Groonga::Context.default_options = {encoding: :utf8}
      path = File.join(PADRINO_ROOT, 'db/rubia.db')

      if File.exists?(path)
        @database = ::Groonga::Database.open(path)
      else
        FileUtils.mkdir_p(File.join(PADRINO_ROOT, 'db'))
        @database = ::Groonga::Database.create(path: path)
        load_schema()
      end
    end

    def load_schema
      Dir.glob(SCHEMA_DIR+'/*.rb').each do |schema_file|
        load schema_file
      end
    end

    module ReposCache
      extend self

      def add(hash, body)
        groonga_key = Digest::MD5.hexdigest(body+Time.now.to_i.to_s+rand().to_s)
        content_body = ::Groonga['ContentBody'].add(groonga_key)
        content_body.body = body
        content_body.commit_hash = hash

        content_body
      end

      def find(query, commit_hash=nil)
        hash = ::Groonga['ContentBody']
        hash.select do |r|
          unless commit_hash.blank?
            r.commit_hash =~ commit_hash
            r.body =~ query
          else
            r.body =~ query
          end
        end
      end
    end
  end
end

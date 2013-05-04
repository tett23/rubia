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
        content_body = ::Groonga['ContentBody'].add(hash)
        content_body.body = body

        content_body
      end

      def find(query)
        ::Groonga['ContentBody'].select do
          |r| r.body =~ query
        end
      end
    end
  end
end

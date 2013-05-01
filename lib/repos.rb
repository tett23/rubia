# coding: utf-8

require 'yaml'

module Rubia
  REPOS_DIR = [PADRINO_ROOT, 'repos'].join('/')

  class Repos
    def initialize(slug, repos)
      @repos = repos
      @slug = slug
      @repos_dir = [REPOS_DIR, slug].join('/')
      @data_dir = [REPOS_DIR, slug, 'data'].join('/')
    end
    attr_accessor :repos
    attr_reader :slug, :repos_dir, :data_dir

    def self.get(slug)
      path = [REPOS_DIR, slug].join('/')

      if Dir.exists?(path)
        repos = open(path)
      else
        repos = create(path)
      end

      Rubia::Repos.new(slug, repos)
    end

    def to_html
      toc_path = [@repos_dir, 'toc.yml'].join('/')
      unless File.exists?(toc_path)
        return 'toc.ymlがない'
      end

      toc = YAML.load_file(toc_path)
      sections = toc.each do |section|
        section.symbolize_keys!
        file = path_finder(section[:ref])

        if file.nil?
          section[:entity] = section[:ext] = nil
        else
          section[:entity] = file
          section[:ext] = file.size.zero? ? nil : File.extname(file)[1..-1]
        end
      end.map do |section|
        compile(section)
      end

      sections.join()
    end

    private
    def path_finder(filename)
      search_file = filename.gsub(/\..+$/, '')

      Dir.entries(@data_dir).find do |entry|
        entry.match(search_file)
      end
    end

    def compile(section)
      return '' if section[:entity].nil?

      file_socket = open([@data_dir, section[:entity]].join('/'), 'r')
      body = file_socket.read
      file_socket.close

      return body if section[:ext].nil?

      case section[:ext].to_sym
      when :textile
        RedCloth.new(body).to_html
      else
        body
      end
    end

    def self.create(create_path)
      Git.init(create_path)

      open(create_path)
    end

    def self.open(open_path)
      Git.open(open_path)
    end
  end
end

# coding: utf-8

Rubia::App.controllers :archives do
  get :download, map: '/accounts/:screen_name/works/:slug/archives/:filename' do |screen_name, slug, filename|
    path = [Rubia::ARCHIVE_DIR, screen_name, filename].join('/')
    error 404 unless File.exists?(path)

    content_type File.extname(filename).gsub(/^\./, '')
    send_file path
  end
end

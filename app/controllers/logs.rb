# coding: utf-8

Rubia::App.controllers :logs do
  get :index, map: '/accounts/:screen_name/works/:slug/logs'  do |screen_name, slug|
    @work = Work.detail(slug)
    exist_or_404(@work)

    @repos = Rubia::Repos.get(slug)
    add_breadcrumbs(screen_name, url(:accounts, :show, screen_name: screen_name))
    add_breadcrumbs(@work.title, url(:works, :show, screen_name: screen_name, slug: slug))
    add_breadcrumbs('logs', url(:logs, :index, screen_name: screen_name, slug: slug))

    render :'logs/index'
  end
end

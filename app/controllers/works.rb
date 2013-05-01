# coding: utf-8

Rubia::App.controllers :works do
  get :index, map: '/accounts/:screen_name/works' do |screen_name|
    @works = Work.list()

    render :'works/index'
  end

  get :show, map: '/accounts/:screen_name/works/:slug'  do |screen_name, slug|
    @work = Work.detail(slug)
    exist_or_404(@work)

    @repos = Rubia::Repos.get(slug)
    add_breadcrumbs(screen_name, url(:accounts, :show, screen_name: screen_name))
    add_breadcrumbs(@work.title, url(:works, :show, screen_name: screen_name, slug: slug))

    render :'works/show'
  end
end

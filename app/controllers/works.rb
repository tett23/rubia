# coding: utf-8

Rubia::App.controllers :works do
  get :index do
    @works = Work.list()

    render :'works/index'
  end

  get :show, with: :slug do |slug|
    @work = Work.detail(slug)
    @repos = Rubia::Repos.get(slug)

    render :'works/show'
  end
end

# coding: utf-8

Rubia::App.controllers :work_search do
  get :index, map: '/accounts/:screen_name/works/:slug/search' do |screen_name, slug|
    @work = Work.detail(slug)
    exist_or_404(@work)
    @slug = slug

    add_breadcrumbs(screen_name, url(:accounts, :show, screen_name: screen_name))
    add_breadcrumbs(@work.title, url(:works, :show, screen_name: screen_name, slug: slug))
    add_breadcrumbs('search', url(:work_search, :index, screen_name: screen_name, slug: slug))

    render :'work_search/index'
  end

  post :index, map: '/accounts/:screen_name/works/:slug/search' do |screen_name, slug|
    @work = Work.detail(slug)
    exist_or_404(@work)
    @slug = slug

    add_breadcrumbs(screen_name, url(:accounts, :show, screen_name: screen_name))
    add_breadcrumbs(@work.title, url(:works, :show, screen_name: screen_name, slug: slug))
    add_breadcrumbs('search', url(:work_search, :index, screen_name: screen_name, slug: slug))

    if params[:work]
      @query = params[:work][:query]
      options = {}
      slug = params[:work][:slug].blank? ? slug : params[:work][:slug]
      options[:work_id] = Work.detail(slug).id

      @result = ReposCache.search(@query, options)
    end

    render :'work_search/index'
  end
end
